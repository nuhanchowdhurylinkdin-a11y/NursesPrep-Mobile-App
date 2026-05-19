import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../../../routes/app_routes.dart';
import '../../controller/todays_focus_controller.dart';
import '../widgets/daily_goal_card.dart';
import '../widgets/exam_readiness_card.dart';
import '../widgets/smart_recommendation_card.dart';
import '../widgets/weak_categories_section.dart';

class TodaysFocusScreen extends GetView<TodaysFocusController> {
  const TodaysFocusScreen({super.key});

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
            "Today's Focus",
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
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  alignment: Alignment.center,
                  child: Icon(
                    Iconsax.notification,
                    size: 24.sp,
                    color: c.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Obx(() {
          final isLoading = controller.isLoading.value;

          return RefreshIndicator(
            onRefresh: controller.fetchTodaysFocus,
            color: const Color(0xFF0F58BD),
            child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            child: Skeletonizer(
              enabled: isLoading,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    SizedBox(height: 16.h),
                    // Exam Readiness
                    ExamReadinessCard(
                      readiness: controller.examReadiness,
                      change: controller.readinessChange,
                      totalQuestions: controller.totalQuestions,
                    ),
                    SizedBox(height: 12.h),
                    // Daily Goal
                    DailyGoalCard(
                      completed: controller.questionsCompleted,
                      goal: controller.dailyGoalTarget,
                      progress: controller.goalProgress,
                      message: controller.goalMessage,
                      onTap: () =>
                          Get.toNamed(AppRoute.getDailyProgressScreen()),
                    ),
                    SizedBox(height: 20.h),
                    // Weak Categories
                    WeakCategoriesSection(
                        categories: controller.weakCategories),
                    SizedBox(height: 16.h),
                    // Smart Recommendation
                    if (!isLoading && controller.recommendation != null)
                      SmartRecommendationCard(
                        title: controller.recommendationTitle,
                        description: controller.recommendationDescription,
                        questionCount:
                            controller.recommendationQuestionCount,
                        onTap: controller.startRecommendedQuiz,
                      ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ),
          );
        }),
      ),
    );
  }
}
