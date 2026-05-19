import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../../../routes/app_routes.dart';
import '../../controller/exam_report_controller.dart';
import '../../model/comprehensive_report_model.dart';

class ExamReportScreen extends GetView<ExamReportController> {
  const ExamReportScreen({super.key});

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
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Comprehensive Report',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Iconsax.share,
                  size: 24.sp,
                  color: const Color(0xFF0F58BD),
                ),
              ),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Skeletonizer(
              enabled: true,
              child: _buildSkeletonBody(context),
            );
          }

          final report = controller.report.value;
          if (report == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.document_text,
                    size: 48.sp,
                    color: c.border,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Report not found',
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: c.textHint,
                    ),
                  ),
                ],
              ),
            );
          }

          return _buildBody(context, report);
        }),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ComprehensiveReportModel report) {
    final c = context.appColors;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  // Score ring
                  Center(
                    child: SizedBox(
                      width: 128.w,
                      height: 128.w,
                      child: CustomPaint(
                        painter: _ScoreRingPainter(
                          score: report.scorePercentage / 100,
                          color: const Color(0xFF0F58BD),
                          bgColor: c.border,
                        ),
                        child: Center(
                          child: Text(
                            '${report.scorePercentage.round()}%',
                            style: getTextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              color: c.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Center(
                    child: Text(
                      'Final Performance Score',
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: c.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Status banner
                  _StatusBanner(
                    passed: report.passed,
                    status: report.nclexStatus,
                    message: report.nclexMessage,
                  ),
                  SizedBox(height: 24.h),
                  // Stats grid
                  Row(
                    children: [
                      Expanded(
                        child: _InfoCard(
                          label: 'Time Spent',
                          value: report.timeSpentLabel,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _InfoCard(
                          label: 'Questions',
                          value: '${report.questionsCount}',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Focus Category
                  if (report.focusCategory != null &&
                      report.focusCategory!.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(17.w),
                      decoration: BoxDecoration(
                        color: c.cardBg,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: c.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Focus Category',
                            style: getTextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: c.textSecondary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            report.focusCategory!,
                            style: getTextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: c.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 24.h),
                  // Filter tabs
                  Obx(() => _FilterTabs(
                        selectedIndex: controller.selectedFilter.value,
                        totalAll: report.tabs.all,
                        totalIncorrect: report.tabs.incorrect,
                        totalCorrect: report.tabs.correct,
                        onChanged: controller.selectFilter,
                      )),
                  SizedBox(height: 20.h),
                  // Detailed Analysis
                  Text(
                    'Detailed Analysis',
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: c.textSecondary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Obx(() => Column(
                        children: controller.filteredQuestions
                            .map((q) => Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: _QuestionCard(question: q),
                                ))
                            .toList(),
                      )),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ),
        ),
        // Bottom buttons
        Container(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.95),
            border: Border(
              top: BorderSide(color: c.border),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFF0F58BD).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'RETAKE EXAM',
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F58BD),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      Get.toNamed(AppRoute.getProgressTrendScreen()),
                  child: Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: c.textPrimary,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'View Trend',
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: c.cardBg,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonBody(BuildContext context) {
    final c = context.appColors;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Center(
              child: Container(
                width: 128.w,
                height: 128.w,
                decoration: BoxDecoration(
                  color: c.shimmer,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SizedBox(height: 32.h),
            Container(
              width: double.infinity,
              height: 80.h,
              decoration: BoxDecoration(
                color: c.shimmer,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 70.h,
                    decoration: BoxDecoration(
                      color: c.shimmer,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Container(
                    height: 70.h,
                    decoration: BoxDecoration(
                      color: c.shimmer,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              height: 70.h,
              decoration: BoxDecoration(
                color: c.shimmer,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(height: 24.h),
            ...List.generate(
              3,
              (_) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Container(
                  width: double.infinity,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: c.shimmer,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Status Banner ───────────────────────────────────────────────

class _StatusBanner extends StatelessWidget {
  final bool passed;
  final String status;
  final String message;

  const _StatusBanner({
    required this.passed,
    required this.status,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        passed ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                passed ? Iconsax.tick_circle : Iconsax.close_circle,
                size: 24.sp,
                color: color,
              ),
              SizedBox(width: 8.w),
              Text(
                '$status - NCLEX STANDARDS',
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: getTextStyle(
              fontSize: 12,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Info Card ───────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;

  const _InfoCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      padding: EdgeInsets.all(17.w),
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
              fontWeight: FontWeight.w700,
              color: c.textSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: getTextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Filter Tabs ─────────────────────────────────────────────────

class _FilterTabs extends StatelessWidget {
  final int selectedIndex;
  final int totalAll;
  final int totalIncorrect;
  final int totalCorrect;
  final ValueChanged<int> onChanged;

  const _FilterTabs({
    required this.selectedIndex,
    required this.totalAll,
    required this.totalIncorrect,
    required this.totalCorrect,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final tabs = [
      'All ($totalAll)',
      'Incorrect ($totalIncorrect)',
      'Correct ($totalCorrect)',
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isActive = selectedIndex == i;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF0F58BD)
                      : c.cardBg,
                  borderRadius: BorderRadius.circular(9999),
                  border: isActive
                      ? null
                      : Border.all(color: c.border),
                ),
                child: Text(
                  tabs[i],
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isActive
                        ? Colors.white
                        : c.textPrimary,
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

// ─── Question Card ───────────────────────────────────────────────

class _QuestionCard extends StatefulWidget {
  final DetailedAnalysisItem question;

  const _QuestionCard({required this.question});

  @override
  State<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<_QuestionCard> {
  bool _showRationale = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final q = widget.question;
    final color =
        q.isCorrect ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Number badge
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${q.index}',
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                q.isCorrect ? Iconsax.tick_circle : Iconsax.close_circle,
                size: 20.sp,
                color: color,
              ),
              const Spacer(),
              // Category tag
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: c.tagBg,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  q.categoryLabel.toUpperCase(),
                  style: getTextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: c.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            q.questionText,
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: c.textBody,
            ),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () => setState(() => _showRationale = !_showRationale),
            child: Row(
              children: [
                Text(
                  _showRationale ? 'HIDE RATIONALE' : 'VIEW RATIONALE',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F58BD),
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  _showRationale
                      ? Iconsax.arrow_up_2
                      : Iconsax.arrow_right_3,
                  size: 14.sp,
                  color: const Color(0xFF0F58BD),
                ),
              ],
            ),
          ),
          if (_showRationale) ...[
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: c.tagBg,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: c.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: q.rationales.entries.map((entry) {
                  final label = entry.key
                      .replaceAll('option_', '')
                      .toUpperCase();
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            color: c.border,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            label,
                            style: getTextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: c.textSecondary,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: getTextStyle(
                              fontSize: 13,
                              color: c.textBody,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Score Ring Painter ──────────────────────────────────────────

class _ScoreRingPainter extends CustomPainter {
  final double score;
  final Color color;
  final Color bgColor;

  _ScoreRingPainter({
    required this.score,
    required this.color,
    required this.bgColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    const strokeWidth = 12.0;

    // Background ring
    final bgPaint = Paint()
      ..color = bgColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress ring
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * score,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
