import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/login_required_dialog.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../../core/utils/helpers/app_helper.dart';
import '../../../routes/app_routes.dart';
import '../../profile/controller/profile_controller.dart';
import '../model/exam_model.dart';
import '../model/practice_session_model.dart';
import '../model/question_review_model.dart';
import '../model/session_result_model.dart';

// Top-level functions for isolate parsing
PracticeSessionModel _parseSession(Map<String, dynamic> json) {
  return PracticeSessionModel.fromJson(json);
}

ExamListResponse _parseExams(List<dynamic> json) {
  return ExamListResponse.fromJson(json);
}

SessionResultModel _parseResult(Map<String, dynamic> json) {
  return SessionResultModel.fromJson(json);
}

QuestionReviewModel _parseReview(Map<String, dynamic> json) {
  return QuestionReviewModel.fromJson(json);
}

class QuizController extends GetxController {
  final _networkCaller = NetworkCaller();

  final isLoading = true.obs;
  final currentIndex = 0.obs;
  final isExamMode = false.obs;

  final Rxn<PracticeSessionModel> session = Rxn<PracticeSessionModel>();
  final Rxn<SessionResultModel> sessionResult = Rxn<SessionResultModel>();
  final isSubmitting = false.obs;

  // Question review state
  final isLoadingReview = false.obs;
  final Rxn<QuestionReviewModel> questionReview = Rxn<QuestionReviewModel>();

  // Map of questionIndex -> Set of selected option keys
  final answers = <int, Set<String>>{}.obs;

  // Timer
  Timer? _timer;
  final remainingSeconds = 0.obs;

  List<SessionQuestion> get questions => session.value?.questions ?? [];
  int get totalQuestions => questions.length;
  SessionQuestion? get currentQuestion =>
      questions.isNotEmpty ? questions[currentIndex.value] : null;
  bool get isLastQuestion => currentIndex.value == totalQuestions - 1;
  Set<String> get currentAnswers => answers[currentIndex.value] ?? {};
  bool get hasAnswered => currentAnswers.isNotEmpty;

  String get timerText {
    final mins = (remainingSeconds.value ~/ 60).toString().padLeft(2, '0');
    final secs = (remainingSeconds.value % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // ─── Resume Session ─────────────────────────────────────────────

  Future<void> resumeSession(String sessionId) async {
    try {
      isLoading.value = true;
      currentIndex.value = 0;
      answers.clear();

      final url = '${ApiConstants.resumeSession}/$sessionId';
      final response = await _networkCaller.getRequest(url);

      if (response.isSuccess) {
        final data = Map<String, dynamic>.from(response.responseData['data']);
        session.value = await compute(_parseSession, data);

        isExamMode.value = session.value?.mode == 'exam';

        // Restore answered questions from session data
        final questions = session.value?.questions ?? [];
        for (int i = 0; i < questions.length; i++) {
          if (questions[i].selectedAnswers.isNotEmpty) {
            answers[i] = Set<String>.from(questions[i].selectedAnswers);
          }
        }

        // Jump to the first unanswered question
        final firstUnanswered = questions.indexWhere(
          (q) => q.selectedAnswers.isEmpty,
        );
        if (firstUnanswered != -1) {
          currentIndex.value = firstUnanswered;
        }

        // Start timer if exam mode with time limit
        if (isExamMode.value && session.value?.timeLimitMinutes != null) {
          final elapsed = session.value?.timeTakenSeconds ?? 0;
          final totalSeconds = session.value!.timeLimitMinutes! * 60;
          remainingSeconds.value = (totalSeconds - elapsed).clamp(0, totalSeconds);
          _startTimer();
        }
      } else {
        AppHelperFunctions.showErrorSnackBar(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to resume session',
        );
        Get.back();
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to resume session');
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Question Review (Premium) ──────────────────────────────────

  bool get _hasPremiumAccess {
    try {
      final profileController = Get.find<ProfileController>();
      return profileController.activeSubscription?.isActive ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> fetchQuestionReview({
    required String sessionId,
    required String sessionQuestionId,
  }) async {
    if (StorageService.isGuest) {
      LoginRequiredDialog.show(
        message:
            'Log in to review wrong answers and unlock detailed explanations.',
      );
      return;
    }

    if (!_hasPremiumAccess) {
      AppHelperFunctions.showErrorSnackBar(
        'Question review is a premium feature. Upgrade to access detailed answer reviews.',
      );
      return;
    }

    try {
      isLoadingReview.value = true;
      questionReview.value = null;

      final url =
          '${ApiConstants.practiceSessions}/$sessionId/questions/$sessionQuestionId/review';
      final response = await _networkCaller.getRequest(url);

      if (response.isSuccess) {
        final data = response.responseData['data'];
        if (data != null) {
          questionReview.value = await compute(
            _parseReview,
            Map<String, dynamic>.from(data),
          );
          Get.toNamed(AppRoute.getQuestionReviewScreen());
        }
      } else {
        AppHelperFunctions.showErrorSnackBar(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to load question review',
        );
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to load question review');
    } finally {
      isLoadingReview.value = false;
    }
  }

  // ─── Practice Mode ──────────────────────────────────────────────

  Future<void> startSession({
    required String mode,
    required String licenseType,
    String? difficultyId,
    String? categoryId,
    String? topicId,
    int questionCount = 10,
    bool randomize = false,
  }) async {
    if (StorageService.isGuest) {
      LoginRequiredDialog.show(
        message:
            'Log in to start a practice session and track your performance.',
      );
      return;
    }

    try {
      isLoading.value = true;
      isExamMode.value = false;
      currentIndex.value = 0;
      answers.clear();

      final body = <String, dynamic>{
        'mode': mode,
        'license_type': licenseType,
        'question_count': questionCount.toString(),
      };
      if (difficultyId != null) body['difficulty_id'] = difficultyId;
      if (categoryId != null) body['category_id'] = categoryId;
      if (topicId != null) body['topic_id'] = topicId;
      if (mode == 'practice') body['randomize'] = randomize;

      final response = await _networkCaller.postRequest(
        ApiConstants.practiceSessions,
        body: body,
      );

      if (response.isSuccess) {
        final data = Map<String, dynamic>.from(response.responseData['data']);
        session.value = await compute(_parseSession, data);
      } else {
        AppHelperFunctions.showErrorSnackBar(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to start session',
        );
        Get.back();
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to start session');
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Exam Mode ──────────────────────────────────────────────────

  final exams = <ExamModel>[].obs;
  final isLoadingExams = false.obs;

  Future<void> fetchExams({
    required String licenseType,
    String? categoryId,
    String? topicId,
  }) async {
    try {
      isLoadingExams.value = true;
      exams.clear();

      final queryParams = <String, String>{
        'licenseType': licenseType,
      };
      if (categoryId != null) queryParams['category'] = categoryId;
      if (topicId != null) queryParams['topic'] = topicId;

      final uri = Uri.parse(ApiConstants.examAll)
          .replace(queryParameters: queryParams);

      final response = await _networkCaller.getRequest(uri.toString());

      if (response.isSuccess) {
        final dataList = List<dynamic>.from(response.responseData['data']);
        final examList = await compute(_parseExams, dataList);
        exams.value = examList.exams;
      } else {
        AppHelperFunctions.showErrorSnackBar(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to load exams',
        );
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to load exams');
    } finally {
      isLoadingExams.value = false;
    }
  }

  Future<void> startExamFromModel(ExamModel exam) async {
    if (StorageService.isGuest) {
      LoginRequiredDialog.show(
        message: 'Log in to take exams and view your detailed results.',
      );
      return;
    }

    try {
      isLoading.value = true;
      isExamMode.value = true;
      currentIndex.value = 0;
      answers.clear();

      final response = await _networkCaller.postRequest(
        ApiConstants.practiceSessions,
        body: {
          'mode': 'exam',
          'exam_id': exam.id,
          'license_type': exam.licenseType,
        },
      );

      if (response.isSuccess) {
        final data = Map<String, dynamic>.from(response.responseData['data']);
        session.value = await compute(_parseSession, data);
        remainingSeconds.value = exam.timeLimit * 60;
        _startTimer();
      } else {
        AppHelperFunctions.showErrorSnackBar(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to start exam',
        );
        Get.back();
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to start exam');
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        _timer?.cancel();
        _onTimeUp();
      }
    });
  }

  void _onTimeUp() {
    _submitCurrentAnswer();
    AppHelperFunctions.showWarningSnackBar('Time is up!');
    Get.back();
  }

  // ─── Quiz Actions ───────────────────────────────────────────────

  void selectOption(String key) {
    final question = currentQuestion;
    if (question == null) return;

    final current = Set<String>.from(currentAnswers);

    if (question.isMultipleChoice) {
      if (current.contains(key)) {
        current.remove(key);
      } else {
        current.add(key);
      }
    } else {
      current.clear();
      current.add(key);
    }

    answers[currentIndex.value] = current;
    answers.refresh();
  }

  void nextQuestion() {
    if (!hasAnswered) return;
    _submitCurrentAnswer(); // fire-and-forget for next, no need to await
    if (currentIndex.value < totalQuestions - 1) {
      currentIndex.value++;
    }
  }

  void previousQuestion() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }

  Future<void> submitAnswers() async {
    if (isSubmitting.value) return;
    isSubmitting.value = true;
    _timer?.cancel();

    final s = session.value;
    if (s == null) return;

    try {
      // Await the last answer PATCH before submitting
      await _submitCurrentAnswer();

      final url = '${ApiConstants.practiceSessions}/${s.id}/submit';
      final response = await _networkCaller.postRequest(url, body: {});

      if (response.isSuccess) {
        final data = Map<String, dynamic>.from(response.responseData['data']);
        sessionResult.value = await compute(_parseResult, data);
        Get.offNamed(AppRoute.getSessionResultScreen());
        return;
      } else {
        final error = response.errorMessage.toLowerCase();
        if (error.contains('already submitted') || error.contains('already submit')) {
          Get.offNamed(AppRoute.getSessionResultScreen());
          return;
        }
        AppHelperFunctions.showErrorSnackBar(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to submit session',
        );
      }
    } catch (e) {
      log('submitAnswers error: $e');
      AppHelperFunctions.showErrorSnackBar('Failed to submit session');
    } finally {
      isSubmitting.value = false;
    }
  }

  // Submit the current question's answer to the server
  Future<void> _submitCurrentAnswer() async {
    final s = session.value;
    final q = currentQuestion;
    if (s == null || q == null) return;

    final selected = currentAnswers.toList();
    if (selected.isEmpty) return;

    final url =
        '${ApiConstants.practiceSessions}/${s.id}/questions/${q.sessionQuestionId}';

    await _networkCaller.patchRequest(url, body: {
      'selected_answers': selected,
    });
  }
}
