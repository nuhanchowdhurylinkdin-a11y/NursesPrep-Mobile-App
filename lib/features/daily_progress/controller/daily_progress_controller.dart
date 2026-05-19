import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/login_required_dialog.dart';
import '../../../core/mock/guest_mock_data.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../../core/utils/helpers/app_helper.dart';
import '../model/daily_progress_model.dart';

DailyProgressModel _parseDailyProgress(Map<String, dynamic> json) {
  return DailyProgressModel.fromJson(json);
}

class DailyProgressController extends GetxController {
  final _networkCaller = NetworkCaller();

  final isLoading = true.obs;
  final isSavingGoal = false.obs;
  final Rxn<DailyProgressModel> data = Rxn<DailyProgressModel>();

  // Progress
  final questionsAnswered = 0.obs;
  final dailyGoal = 50.obs;

  double get progressPercent =>
      dailyGoal.value > 0 ? questionsAnswered.value / dailyGoal.value : 0;
  int get progressPercentInt => (progressPercent * 100).round();
  String get progressMessage => data.value?.dailyProgress.message ?? '';

  // Active Session
  ActiveSession? get activeSession => data.value?.activeSession;
  bool get hasActiveSession =>
      activeSession != null && activeSession!.status == 'in_progress';

  // Streak
  int get streakDays => data.value?.streak.currentDays ?? 0;
  String get streakMessage => data.value?.streak.message ?? '';

  // Weekly Performance
  int get weeklyTotal => data.value?.weeklyPerformance.totalAnswered ?? 0;

  String get weeklyChange {
    final change = data.value?.weeklyPerformance.changePercentage ?? 0;
    if (change == 0) return 'No change vs last week';
    final prefix = change > 0 ? '+' : '';
    return '$prefix${change % 1 == 0 ? change.toInt() : change}% vs last week';
  }

  List<double> get weeklyData =>
      data.value?.weeklyPerformance.series
          .map((s) => s.answeredQuestions.toDouble())
          .toList() ??
      [];

  List<String> get weekDays =>
      data.value?.weeklyPerformance.series
          .map((s) => s.label)
          .toList() ??
      [];

  // Daily Goal Slider
  final sliderValue = 50.0.obs;

  List<int> get allowedOptions =>
      data.value?.dailyGoal.allowedOptions ?? [10, 25, 50, 100, 150, 200];

  double get sliderMin =>
      allowedOptions.isNotEmpty ? allowedOptions.first.toDouble() : 10;

  double get sliderMax =>
      allowedOptions.isNotEmpty ? allowedOptions.last.toDouble() : 200;

  @override
  void onInit() {
    super.onInit();
    fetchDailyProgress();
  }

  Future<void> fetchDailyProgress() async {
    if (StorageService.isGuest) {
      data.value = GuestMockData.dailyProgress;
      questionsAnswered.value = data.value!.dailyProgress.answeredQuestions;
      dailyGoal.value = data.value!.dailyProgress.targetQuestions;
      sliderValue.value = data.value!.dailyGoal.currentTarget.toDouble();
      isLoading.value = false;
      return;
    }

    try {
      isLoading.value = true;

      final response =
          await _networkCaller.getRequest(ApiConstants.dailyProgress);

      if (response.isSuccess) {
        final responseData = response.responseData['data'];
        if (responseData != null) {
          data.value = await compute(
            _parseDailyProgress,
            Map<String, dynamic>.from(responseData),
          );

          questionsAnswered.value =
              data.value!.dailyProgress.answeredQuestions;
          dailyGoal.value = data.value!.dailyProgress.targetQuestions;
          sliderValue.value = data.value!.dailyGoal.currentTarget.toDouble();
        }
      } else {
        AppHelperFunctions.showErrorSnackBar(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to load daily progress',
        );
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to load daily progress');
    } finally {
      isLoading.value = false;
    }
  }

  void updateSlider(double value) {
    // Snap to nearest allowed option
    final closest = allowedOptions.reduce((a, b) =>
        (a - value).abs() < (b - value).abs() ? a : b);
    sliderValue.value = closest.toDouble();
  }

  Future<void> saveDailyGoal() async {
    if (StorageService.isGuest) {
      LoginRequiredDialog.show(
        message: 'Log in to save your daily question goal and track streaks.',
      );
      return;
    }

    if (isSavingGoal.value) return;
    isSavingGoal.value = true;

    try {
      final response = await _networkCaller.patchRequest(
        ApiConstants.dailyGoal,
        body: {'target_questions': sliderValue.value.toInt()},
      );

      if (response.isSuccess) {
        dailyGoal.value = sliderValue.value.toInt();
        AppHelperFunctions.showSuccessSnackBar('Daily goal updated');
      } else {
        AppHelperFunctions.showErrorSnackBar(
          response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to update daily goal',
        );
      }
    } catch (e) {
      AppHelperFunctions.showErrorSnackBar('Failed to update daily goal');
    } finally {
      isSavingGoal.value = false;
    }
  }
}
