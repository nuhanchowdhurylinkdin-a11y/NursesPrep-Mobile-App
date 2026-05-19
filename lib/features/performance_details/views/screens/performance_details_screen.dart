import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../controller/performance_details_controller.dart';
import '../widgets/accuracy_chart_card.dart';
import '../widgets/stat_cards.dart';
import '../widgets/time_filter_tabs.dart';
import '../widgets/topic_mastery_section.dart';

class PerformanceDetailsScreen extends GetView<PerformanceDetailsController> {
  const PerformanceDetailsScreen({super.key});

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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8),
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios,
                size: 24.sp, color: const Color(0xFF0F58BD)),
          ),
          title: Text(
            'Performance Details',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 8.h),
              // Time filter tabs
              Obx(
                () => TimeFilterTabs(
                  filters: controller.filterOptions,
                  selectedIndex: controller.selectedFilterIndex.value,
                  onSelected: controller.selectFilter,
                ),
              ),
              SizedBox(height: 16.h),
              // Content
              Obx(() {
                final isLoading = controller.isLoading.value;

                return Skeletonizer(
                  enabled: isLoading,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        // Accuracy chart
                        AccuracyChartCard(
                          overallAccuracy: controller.overallAccuracy,
                          accuracyChange: controller.accuracyChange,
                          weeklyData: controller.weeklyAccuracy,
                          weekDays: controller.weekDays,
                        ),
                        SizedBox(height: 16.h),
                        // Stat cards
                        StatCards(
                          timePerQuestion: controller.timePerQuestion,
                          timeImprovement: controller.timeImprovement,
                          studyHours: controller.studyHours,
                          studyHoursChange: controller.studyHoursChange,
                        ),
                        SizedBox(height: 24.h),
                        // Topic Mastery
                        TopicMasterySection(topics: controller.topics),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
