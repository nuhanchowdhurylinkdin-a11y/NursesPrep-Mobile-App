import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/login_required_dialog.dart';
import '../../../../core/common/widgets/staggered_fade_in.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../../../routes/app_routes.dart';
import '../../../main_nav/controller/main_nav_controller.dart';
import '../../controller/exam_history_controller.dart';
import '../../model/exam_history_model.dart';

class ExamHistoryScreen extends GetView<ExamHistoryController> {
  const ExamHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Exam History',
          style: getTextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
        ),
      ),
      body: Obx(() {
        final navController = Get.find<MainNavController>();
        final animate = navController.currentIndex.value == 3;

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification &&
                notification.metrics.pixels >=
                    notification.metrics.maxScrollExtent - 100) {
              controller.loadMore();
            }
            return false;
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  // Stats row
                  StaggeredFadeIn(
                    index: 0,
                    enabled: animate,
                    child: Skeletonizer(
                      enabled: controller.isLoadingSummary.value,
                      child: Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'Avg. Score',
                              value:
                                  '${controller.avgScore.value.toStringAsFixed(1)}%',
                              valueColor: const Color(0xFF0F58BD),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _StatCard(
                              label: 'Total Exams',
                              value: '${controller.totalExams.value}',
                              valueColor: c.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Search bar
                  StaggeredFadeIn(
                    index: 1,
                    enabled: animate,
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: c.fieldBg,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: c.border),
                      ),
                      child: TextField(
                        onChanged: (val) =>
                            controller.searchQuery.value = val,
                        style: getTextStyle(
                          fontSize: 16,
                          color: c.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search by exam name...',
                          hintStyle: getTextStyle(
                            fontSize: 16,
                            color: c.textHint,
                          ),
                          prefixIcon: Icon(
                            Iconsax.search_normal_1,
                            size: 20.sp,
                            color: c.textHint,
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 14.h),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Recent Exams header + filter
                  StaggeredFadeIn(
                    index: 2,
                    enabled: animate,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Exams',
                          style: getTextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: c.textPrimary,
                          ),
                        ),
                        _ModeFilterButton(
                          selectedMode: controller.selectedMode.value,
                          onChanged: controller.setMode,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Exam list
                  if (controller.isLoadingHistory.value &&
                      controller.exams.isEmpty)
                    Skeletonizer(
                      enabled: true,
                      child: Column(
                        children: List.generate(
                          4,
                          (i) => Padding(
                            padding: EdgeInsets.only(bottom: 4.h),
                            child: _ExamTileSkeleton(),
                          ),
                        ),
                      ),
                    )
                  else if (controller.exams.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.h),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Iconsax.document_text,
                              size: 48.sp,
                              color: c.border,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'No exams found',
                              style: getTextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: c.textHint,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else ...[
                    ...controller.exams.asMap().entries.map(
                          (entry) => StaggeredFadeIn(
                            index: (3 + entry.key).clamp(0, 10),
                            enabled: animate,
                            stagger: const Duration(milliseconds: 70),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 4.h),
                              child:
                                  _ExamTile(exam: entry.value),
                            ),
                          ),
                        ),
                    if (controller.isLoadingHistory.value)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF0F58BD),
                          ),
                        ),
                      ),
                  ],
                  SizedBox(height: 12.h),
                  // Footer
                  if (controller.exams.isNotEmpty)
                    StaggeredFadeIn(
                      index:
                          (4 + controller.exams.length).clamp(0, 11),
                      enabled: animate,
                      stagger: const Duration(milliseconds: 70),
                      child: Center(
                        child: Text(
                          'Viewing ${controller.exams.length} of ${controller.totalResults.value} results',
                          style: getTextStyle(
                            fontSize: 14,
                            color: c.textHint,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

// ─── Mode Filter Button ──────────────────────────────────────────

class _ModeFilterButton extends StatelessWidget {
  final String selectedMode;
  final ValueChanged<String> onChanged;

  const _ModeFilterButton({
    required this.selectedMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onChanged,
      offset: Offset(0, 36.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _label(selectedMode),
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F58BD),
            ),
          ),
          SizedBox(width: 4.w),
          Icon(
            Iconsax.arrow_down_1,
            size: 16.sp,
            color: const Color(0xFF0F58BD),
          ),
        ],
      ),
      itemBuilder: (_) {
        final c = context.appColors;
        return [
          _buildItem('all', selectedMode, c),
          _buildItem('exam', selectedMode, c),
          _buildItem('practice', selectedMode, c),
        ];
      },
    );
  }

  PopupMenuItem<String> _buildItem(
      String value, String current, AppColorsExtension c) {
    final isSelected = value == current;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          if (isSelected)
            Icon(Iconsax.tick_circle,
                size: 18.sp, color: const Color(0xFF0F58BD))
          else
            SizedBox(width: 18.sp),
          SizedBox(width: 8.w),
          Text(
            _label(value),
            style: getTextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF0F58BD)
                  : c.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _label(String mode) {
    switch (mode) {
      case 'exam':
        return 'Exam';
      case 'practice':
        return 'Practice';
      default:
        return 'All';
    }
  }
}

// ─── Stat Card ───────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: c.textSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: getTextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Exam Tile ───────────────────────────────────────────────────

class _ExamTile extends StatelessWidget {
  final ExamHistoryItem exam;

  const _ExamTile({required this.exam});

  String get _displayTitle {
    if (exam.examTitle.isNotEmpty) return exam.examTitle;
    if (exam.title.isNotEmpty) return exam.title;
    if (exam.mode == 'practice') {
      if (exam.topic != null && exam.topic!.isNotEmpty) return exam.topic!;
      if (exam.category != null && exam.category!.isNotEmpty) return exam.category!;
      return 'Practice Session';
    }
    return 'Exam Session';
  }

  String get _formattedDate {
    final d = exam.submittedAt;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return GestureDetector(
      onTap: () {
        if (StorageService.isGuest) {
          LoginRequiredDialog.show(
            message:
                'Log in to view detailed exam reports and review your wrong answers.',
          );
          return;
        }
        Get.toNamed(
          AppRoute.getExamReportScreen(),
          arguments: {'sessionId': exam.id},
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        color: c.cardBg,
        child: Row(
          children: [
            // Icon
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: const Color(0xFF0F58BD).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              alignment: Alignment.center,
              child: Icon(
                Iconsax.document_text,
                size: 24.sp,
                color: const Color(0xFF0F58BD),
              ),
            ),
            SizedBox(width: 12.w),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _displayTitle,
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        _formattedDate,
                        style: getTextStyle(
                          fontSize: 12,
                          color: c.textSecondary,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Text(
                          '•',
                          style: getTextStyle(
                            fontSize: 16,
                            color: c.border,
                          ),
                        ),
                      ),
                      Text(
                        exam.timeSpentLabel,
                        style: getTextStyle(
                          fontSize: 12,
                          color: c.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Score + status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${exam.scorePercentage.round()}%',
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: exam.passed
                        ? const Color(0xFF0F58BD)
                        : const Color(0xFFF97316),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  exam.passLabel,
                  style: getTextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: exam.passed
                        ? const Color(0xFF16A34A)
                        : const Color(0xFFF97316),
                  ),
                ),
              ],
            ),
            SizedBox(width: 4.w),
            Icon(
              Iconsax.arrow_right_3,
              size: 20.sp,
              color: c.border,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Skeleton Tile ───────────────────────────────────────────────

class _ExamTileSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      color: c.cardBg,
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: c.shimmer,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 160.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: c.shimmer,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  width: 100.w,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: c.shimmer,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 40.w,
            height: 20.h,
            decoration: BoxDecoration(
              color: c.shimmer,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ),
    );
  }
}
