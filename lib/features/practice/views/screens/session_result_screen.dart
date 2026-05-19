import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../../../routes/app_routes.dart';
import '../../controller/quiz_controller.dart';
import '../../model/session_result_model.dart';

class SessionResultScreen extends GetView<QuizController> {
  SessionResultScreen({super.key});

  final _activeFilter = 'all'.obs;

  @override
  Widget build(BuildContext context) {
    final result = controller.sessionResult.value;
    if (result == null) {
      return const Scaffold(
        body: Center(child: Text('No result data')),
      );
    }

    final isExam = result.mode == 'exam';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios,
                size: 24.sp, color: const Color(0xFF0F58BD)),
          ),
          centerTitle: true,
          title: Text(
            isExam ? 'Exam Report' : 'Practice Report',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: context.appColors.textPrimary,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                if (isExam) ...[
                  _buildExamTopCards(context, result),
                  SizedBox(height: 12.h),
                  _buildExamInfoRow(context, result),
                ] else ...[
                  _buildPracticeSummaryCard(context, result),
                ],
                SizedBox(height: 24.h),
                _buildPerformanceBreakdown(context, result, isExam),
                SizedBox(height: 120.h),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildFooter(context, result, isExam),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // EXAM MODE - Top Stats
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildExamTopCards(BuildContext context, SessionResultModel result) {
    final c = context.appColors;
    final summary = result.summary;
    final score = summary.scorePercentage;
    final nclexStatus = summary.nclexStatus ?? (summary.passed ? 'PASS' : 'FAIL');
    final passed = summary.passed;

    return Row(
      children: [
        // Final Score card
        Expanded(
          child: Container(
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
                  'FINAL SCORE',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: c.textSecondary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '$score%',
                  style: getTextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F58BD),
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      passed ? Iconsax.trend_up : Iconsax.trend_down,
                      size: 14.sp,
                      color: passed
                          ? const Color(0xFF07883B)
                          : const Color(0xFFDC2626),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      passed ? 'Above passing' : 'Below passing',
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: passed
                            ? const Color(0xFF07883B)
                            : const Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        // NCLEX Status card
        Expanded(
          child: Container(
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
                  'NCLEX STATUS',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: c.textSecondary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  nclexStatus,
                  style: getTextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: passed
                        ? const Color(0xFF07883B)
                        : const Color(0xFFDC2626),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  passed ? 'Above Standard' : 'Below Standard',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: c.textHint,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExamInfoRow(BuildContext context, SessionResultModel result) {
    final c = context.appColors;
    final summary = result.summary;
    final timeTaken = summary.timeTakenSeconds ?? 0;
    final mins = timeTaken ~/ 60;
    final secs = timeTaken % 60;
    final timeText = '${mins}m ${secs}s';

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: const Color(0xFF0F58BD).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                  color: const Color(0xFF0F58BD).withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Icon(Iconsax.clock, size: 24.sp, color: const Color(0xFF0F58BD)),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time Taken',
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: c.textSecondary,
                      ),
                    ),
                    Text(
                      timeText,
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: const Color(0xFF0F58BD).withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                  color: const Color(0xFF0F58BD).withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Icon(Iconsax.document_text,
                    size: 24.sp, color: const Color(0xFF0F58BD)),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Questions',
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: c.textSecondary,
                      ),
                    ),
                    Text(
                      '${result.summary.totalQuestions} Total',
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // PRACTICE MODE - Summary Card with Accuracy Circle
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildPracticeSummaryCard(BuildContext context, SessionResultModel result) {
    final c = context.appColors;
    final summary = result.summary;
    final accuracy = summary.scorePercentage;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: c.border),
      ),
      child: Column(
        children: [
          Text(
            'Session Complete',
            style: getTextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: c.textSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Report',
            style: getTextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
          SizedBox(height: 20.h),
          _buildAccuracyCircle(context, accuracy),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: _buildStatBox(
                  label: 'Correct',
                  value: '${summary.correctCount}',
                  color: const Color(0xFF059669),
                  bgColor: const Color(0xFFECFDF5),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatBox(
                  label: 'Incorrect',
                  value: '${summary.incorrectCount}',
                  color: const Color(0xFFDC2626),
                  bgColor: const Color(0xFFFEF2F2),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatBox(
                  label: 'Total Qs',
                  value: '${summary.totalQuestions}',
                  color: c.textSecondary,
                  bgColor: c.tagBg,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccuracyCircle(BuildContext context, int accuracy) {
    final c = context.appColors;
    final color = accuracy >= 70
        ? const Color(0xFF059669)
        : accuracy >= 40
            ? const Color(0xFFD97706)
            : const Color(0xFFDC2626);

    return SizedBox(
      width: 140.w,
      height: 140.w,
      child: CustomPaint(
        painter: _AccuracyPainter(
          progress: accuracy / 100,
          color: color,
          trackColor: c.border,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$accuracy%',
                style: getTextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              Text(
                'Accuracy',
                style: getTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: c.textHint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBox({
    required String label,
    required String value,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: getTextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  // SHARED - Performance Breakdown
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildPerformanceBreakdown(BuildContext context, SessionResultModel result, bool isExam) {
    final c = context.appColors;
    final breakdown = result.performanceBreakdown;
    final tabs = breakdown.tabs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          breakdown.title,
          style: getTextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          breakdown.subtitle,
          style: getTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: c.textSecondary,
          ),
        ),
        SizedBox(height: 16.h),
        _buildFilterTabs(context, tabs, isExam),
        SizedBox(height: 16.h),
        Obx(() {
          final filter = _activeFilter.value;
          final items = breakdown.reviewItems.where((item) {
            if (filter == 'all') return true;
            if (filter == 'correct') return item.isCorrect;
            return !item.isCorrect;
          }).toList();

          if (items.isEmpty) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: Center(
                child: Text(
                  'No questions in this category',
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: c.textHint,
                  ),
                ),
              ),
            );
          }

          return Column(
            children: items
                .map((item) => Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: _buildPracticeReviewCard(context, item),
                    ))
                .toList(),
          );
        }),
      ],
    );
  }

  Widget _buildFilterTabs(BuildContext context, BreakdownTabs tabs, bool isExam) {
    return Obx(() => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildTab(context, tabs.all.label, 'all', isExam: isExam),
              SizedBox(width: 8.w),
              _buildTab(context, tabs.correct.label, 'correct',
                  icon: Icons.check_circle, iconColor: const Color(0xFF07883B), isExam: isExam),
              SizedBox(width: 8.w),
              _buildTab(context, tabs.incorrect.label, 'incorrect',
                  icon: Icons.cancel, iconColor: const Color(0xFFEF4444), isExam: isExam),
            ],
          ),
        ));
  }

  Widget _buildTab(BuildContext context, String label, String value,
      {IconData? icon, Color? iconColor, bool isExam = false}) {
    final c = context.appColors;
    final isActive = _activeFilter.value == value;
    return GestureDetector(
      onTap: () => _activeFilter.value = value,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0F58BD) : c.cardBg,
          borderRadius: BorderRadius.circular(9999.r),
          border: Border.all(
            color: isActive
                ? const Color(0xFF0F58BD)
                : c.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null && !isActive) ...[
              Icon(icon, size: 18.sp, color: iconColor),
              SizedBox(width: 6.w),
            ],
            Text(
              label,
              style: getTextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? Colors.white : c.textBody,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Practice Review Card (simple) ───────────────────────────────
  Widget _buildPracticeReviewCard(BuildContext context, ReviewItem item) {
    final c = context.appColors;
    final isCorrect = item.isCorrect;
    final statusColor =
        isCorrect ? const Color(0xFF07883B) : const Color(0xFFEF4444);
    final statusBg = isCorrect
        ? const Color(0xFF07883B).withOpacity(0.1)
        : const Color(0xFFEF4444).withOpacity(0.1);
    final statusIcon =
        isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded;

    return GestureDetector(
      onTap: () {
        final sessionId = controller.sessionResult.value?.id;
        if (sessionId == null || sessionId.isEmpty) return;
        controller.fetchQuestionReview(
          sessionId: sessionId,
          sessionQuestionId: item.sessionQuestionId,
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: c.cardBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: c.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: Icon(statusIcon, size: 24.sp, color: statusColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.cardTitle,
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    item.categoryLabel,
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: c.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14.sp,
              color: c.textHint,
            ),
          ],
        ),
      ),
    );
  }


  // ═══════════════════════════════════════════════════════════════════
  // FOOTER
  // ═══════════════════════════════════════════════════════════════════

  Widget _buildFooter(BuildContext context, SessionResultModel result, bool isExam) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isExam) ...[
              _buildFooterButton(
                label: 'Retake Mock Exam',
                onTap: () => Get.back(),
              ),
              SizedBox(height: 10.h),
            ],
            _buildFooterButton(
              label: 'See Progress',
              onTap: () => Get.toNamed(AppRoute.getProgressTrendScreen()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          color: const Color(0xFF0F58BD),
          borderRadius: BorderRadius.circular(12.r),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ─── Accuracy Ring Painter ───────────────────────────────────────────
class _AccuracyPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;

  _AccuracyPainter({required this.progress, required this.color, required this.trackColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 10.0;

    final bgPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, bgPaint);

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _AccuracyPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color || oldDelegate.trackColor != trackColor;
}
