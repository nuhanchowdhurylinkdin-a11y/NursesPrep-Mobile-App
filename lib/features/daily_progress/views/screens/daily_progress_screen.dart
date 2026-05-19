import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../../../routes/app_routes.dart';
import '../../../practice/controller/quiz_controller.dart';
import '../../controller/daily_progress_controller.dart';
import '../widgets/adjust_goal_card.dart';
import '../widgets/progress_ring.dart';
import '../widgets/streak_card.dart';
import '../widgets/weekly_performance_card.dart';

class DailyProgressScreen extends GetView<DailyProgressController> {
  const DailyProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: c.cardBg,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios,
                size: 24.sp, color: const Color(0xFF0F58BD)),
          ),
          title: Text(
            'Daily Progress',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: GestureDetector(
                onTap: () => Get.toNamed(AppRoute.getNotificationsScreen()),
                child: Icon(
                  Iconsax.notification,
                  size: 24.sp,
                  color: c.textPrimary,
                ),
              ),
            ),
          ],
        ),
        body: Obx(() {
          final isLoading = controller.isLoading.value;

          return RefreshIndicator(
            onRefresh: controller.fetchDailyProgress,
            color: const Color(0xFF0F58BD),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              child: Skeletonizer(
                enabled: isLoading,
                child: Column(
                  children: [
                    // Progress ring section
                    ProgressRing(
                      answered: controller.questionsAnswered.value,
                      goal: controller.dailyGoal.value,
                      progress: controller.progressPercent,
                      message: controller.progressMessage,
                      hasActiveSession: controller.hasActiveSession,
                      onResume: () {
                        final session = controller.activeSession!;
                        final quizController = Get.put(QuizController());
                        quizController.resumeSession(session.sessionId);
                        Get.toNamed(AppRoute.getQuizScreen());
                      },
                    ),
                    SizedBox(height: 8.h),
                    // Cards with padding
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          // Streak
                          StreakCard(
                            streakDays: controller.streakDays,
                            message: controller.streakMessage,
                          ),
                          SizedBox(height: 16.h),
                          // Weekly Performance
                          WeeklyPerformanceCard(
                            totalQuestions: controller.weeklyTotal,
                            changeText: controller.weeklyChange,
                            weeklyData: controller.weeklyData,
                            weekDays: controller.weekDays,
                          ),
                          SizedBox(height: 16.h),
                          // Adjust Goal
                          AdjustGoalCard(
                            sliderValue: controller.sliderValue.value,
                            sliderMin: controller.sliderMin,
                            sliderMax: controller.sliderMax,
                            allowedOptions: controller.allowedOptions,
                            onChanged: controller.updateSlider,
                            onSave: controller.saveDailyGoal,
                            isSaving: controller.isSavingGoal.value,
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
