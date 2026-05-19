import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/common/widgets/license_required_dialog.dart';
import '../../../../core/common/widgets/staggered_fade_in.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../../../routes/app_routes.dart';
import '../../../practice/controller/practice_controller.dart';
import '../../../profile/controller/profile_controller.dart';
import '../../controller/home_controller.dart';
import '../widgets/action_cards.dart';
import '../widgets/focus_needed_card.dart';
import '../widgets/performance_summary_card.dart';
import '../widgets/personalized_path_card.dart';
import '../widgets/todays_progress_card.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: Obx(() {
          final url = Get.find<ProfileController>().avatarUrl;
          return CircleAvatar(
            radius: 18.r,
            backgroundColor: c.border,
            backgroundImage: url.isNotEmpty ? NetworkImage(url) : null,
            child: url.isEmpty
                ? Icon(Iconsax.user, size: 20.sp, color: c.textHint)
                : null,
          );
        }).paddingOnly(left: 16.w),
        centerTitle: false,
        title: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome, ${controller.displayName}",
                  style: TextStyle(
                    color: c.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${controller.licenseName.value} Candidate',
                  style: const TextStyle(
                    color: Color(0xFF0F58BD),
                    fontSize: 11,
                  ),
                ),
              ],
            )),
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
      body: Obx(() => RefreshIndicator(
            onRefresh: controller.fetchDashboard,
            color: const Color(0xFF0F58BD),
            child: Skeletonizer(
              enabled: controller.isLoading.value,
              child: Builder(builder: (context) {
                final animate = !controller.isLoading.value;
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        // Performance Summary
                        StaggeredFadeIn(
                          index: 0,
                          enabled: animate,
                          child: PerformanceSummaryCard(
                            accuracy: controller.accuracy.value.toDouble(),
                            accuracyChange: 0,
                            totalExams: controller.examsTotal.value,
                            onDetailsTap: () => Get.toNamed(
                                AppRoute.getPerformanceDetailsScreen()),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Focus Needed (only show if available)
                        if (controller.focusNeeded.value != null)
                          StaggeredFadeIn(
                            index: 1,
                            enabled: animate,
                            child: FocusNeededCard(
                              topic: controller.focusNeeded.value!.title,
                              score: controller
                                  .focusNeeded.value!.averageScore
                                  .toDouble(),
                              threshold: 75,
                              change: 0,
                            ),
                          ),
                        if (controller.focusNeeded.value != null)
                          SizedBox(height: 16.h),
                        // Personalized Path
                        StaggeredFadeIn(
                          index: 2,
                          enabled: animate,
                          child: PersonalizedPathCard(
                            onTap: () =>
                                Get.toNamed(AppRoute.getTodaysFocusScreen()),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Start Practice
                        StaggeredFadeIn(
                          index: 3,
                          enabled: animate,
                          child: StartPracticeCard(
                            onTap: () {
                              if (!LicenseRequiredDialog.checkAndProceed()) return;
                              Get.find<PracticeController>()
                                  .setMode(PracticeMode.practice);
                              Get.toNamed(AppRoute.getPracticeSetupScreen());
                            },
                          ),
                        ),
                        SizedBox(height: 12.h),
                        // Take Exam
                        StaggeredFadeIn(
                          index: 4,
                          enabled: animate,
                          child: TakeExamCard(
                            onTap: () {
                              if (!LicenseRequiredDialog.checkAndProceed()) return;
                              Get.find<PracticeController>()
                                  .setMode(PracticeMode.exam);
                              Get.toNamed(AppRoute.getPracticeSetupScreen());
                            },
                          ),
                        ),
                        SizedBox(height: 20.h),
                        // Today's Progress
                        StaggeredFadeIn(
                          index: 5,
                          enabled: animate,
                          child: TodaysProgressCard(
                            questionsAnswered:
                                controller.answeredQuestions.value,
                            dailyGoal: controller.targetQuestions.value,
                            progressPercent:
                                controller.completionPercentage.value,
                            onTap: () => Get.toNamed(
                                AppRoute.getDailyProgressScreen()),
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                );
              }),
            ),
          )),
    );
  }
}
