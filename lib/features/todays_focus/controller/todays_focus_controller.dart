import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/login_required_dialog.dart';
import '../../../core/mock/guest_mock_data.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../../core/utils/helpers/app_helper.dart';
import '../../../routes/app_routes.dart';
import '../../home/controller/home_controller.dart';
import '../../practice/controller/quiz_controller.dart';
import '../model/todays_focus_model.dart';

TodaysFocusModel _parseTodaysFocus(Map<String, dynamic> json) {
  return TodaysFocusModel.fromJson(json);
}

class TodaysFocusController extends GetxController {
  final _networkCaller = NetworkCaller();

  final isLoading = true.obs;
  final Rxn<TodaysFocusModel> data = Rxn<TodaysFocusModel>();

  // Convenience getters
  double get examReadiness => data.value?.examReadiness.percentage ?? 0;
  double get readinessChange => data.value?.examReadiness.changePercentage ?? 0;
  int get totalQuestions => data.value?.examReadiness.basedOnQuestions ?? 0;

  int get questionsCompleted =>
      data.value?.dailyQuestionGoal.answeredQuestions ?? 0;
  int get dailyGoalTarget =>
      data.value?.dailyQuestionGoal.targetQuestions ?? 50;
  double get goalProgress =>
      dailyGoalTarget > 0 ? questionsCompleted / dailyGoalTarget : 0;
  int get questionsRemaining =>
      data.value?.dailyQuestionGoal.remainingQuestions ?? 0;
  String get goalMessage => data.value?.dailyQuestionGoal.message ?? '';

  List<WeakCategoryItem> get weakCategories =>
      data.value?.weakCategories ?? [];

  SmartRecommendation? get recommendation => data.value?.smartRecommendation;
  String get recommendationTitle => recommendation?.title ?? '';
  String get recommendationDescription => recommendation?.description ?? '';
  int get recommendationQuestionCount => recommendation?.questionCount ?? 20;

  @override
  void onInit() {
    super.onInit();
    fetchTodaysFocus();
  }

  Future<void> fetchTodaysFocus() async {
    if (StorageService.isGuest) {
      data.value = GuestMockData.todaysFocus;
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;

      final response = await _networkCaller.getRequest(ApiConstants.todaysFocus);

      if (response.isSuccess) {
        final responseData = response.responseData['data'];
        if (responseData != null) {
          data.value = await compute(
            _parseTodaysFocus,
            Map<String, dynamic>.from(responseData),
          );
        }
      } else {
        AppHelperFunctions.showErrorSnackBar(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : "Failed to load today's focus",
        );
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar("Failed to load today's focus");
    } finally {
      isLoading.value = false;
    }
  }

  void startRecommendedQuiz() {
    if (StorageService.isGuest) {
      LoginRequiredDialog.show(
        message:
            'Log in to start a personalized practice session and track your progress.',
      );
      return;
    }

    final action = recommendation?.action;
    if (action == null) return;

    final homeController = Get.find<HomeController>();
    final quizController = Get.put(QuizController());

    quizController.startSession(
      mode: action.mode,
      licenseType: homeController.licenseName.value,
      categoryId: action.categoryId,
      topicId: action.topicId,
      questionCount: action.questionCount,
      randomize: action.randomize,
    );

    Get.toNamed(AppRoute.getQuizScreen());
  }
}
