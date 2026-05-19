import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../controller/quiz_controller.dart';

class QuizScreen extends GetView<QuizController> {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Obx(() {
          final isLoading = controller.isLoading.value;
          final hasData = controller.session.value != null;

          if (!isLoading && !hasData) {
            return const Center(child: Text('No session data'));
          }

          return SafeArea(
            child: Skeletonizer(
              enabled: isLoading,
              child: Column(
                children: [
                  isLoading ? _buildSkeletonHeader(context) : _buildHeader(context),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: isLoading
                            ? _buildSkeletonBody()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 24.h),
                                  _buildCategoryBadge(),
                                  SizedBox(height: 16.h),
                                  _buildQuestionText(context),
                                  SizedBox(height: 24.h),
                                  _buildOptions(context),
                                  if (controller.hasAnswered &&
                                      !controller.isExamMode.value) ...[
                                    SizedBox(height: 16.h),
                                    _buildRationale(context),
                                  ],
                                  SizedBox(height: 120.h),
                                ],
                              ),
                      ),
                    ),
                  ),
                  if (!isLoading) _buildFooter(context),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ─── Skeleton Loading ─────────────────────────────────────────────
  Widget _buildSkeletonHeader(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.arrow_back_ios,
                  size: 24.sp, color: context.appColors.border),
              SizedBox(width: 8.w),
              const Bone.text(words: 3),
              const Spacer(),
              Bone.circle(size: 32.sp),
              SizedBox(width: 8.w),
              Bone.circle(size: 32.sp),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              const Bone.text(words: 2),
              const Spacer(),
            ],
          ),
          SizedBox(height: 8.h),
          Bone(
            height: 6.h,
            width: double.infinity,
            borderRadius: BorderRadius.circular(9999.r),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildSkeletonBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24.h),
        // Category badge
        Bone(
          height: 30.h,
          width: 140.w,
          borderRadius: BorderRadius.circular(9999.r),
        ),
        SizedBox(height: 16.h),
        // Question text
        const Bone.multiText(lines: 4),
        SizedBox(height: 24.h),
        // Options
        ...List.generate(
          4,
          (i) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Bone(
              height: 72.h,
              width: double.infinity,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
        SizedBox(height: 120.h),
      ],
    );
  }

  // ─── Header ──────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    final c = context.appColors;
    final session = controller.session.value!;
    final current = controller.currentIndex.value + 1;
    final total = controller.totalQuestions;
    final progress = total > 0 ? current / total : 0.0;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => _confirmExit(context),
                child: Icon(Icons.arrow_back_ios,
                    size: 24.sp, color: const Color(0xFF0F58BD)),
              ),
              SizedBox(width: 8.w),
              Text(
                'Question $current of $total',
                style: getTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
              const Spacer(),
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(Iconsax.archive_1,
              //       size: 24.sp, color: const Color(0xFF64748B)),
              // ),
              // IconButton(
              //   onPressed: () {},
              //   icon: Icon(Iconsax.flag,
              //       size: 24.sp, color: const Color(0xFF64748B)),
              // ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text(
                session.mode == 'exam' ? 'Exam Progress' : 'Practice Progress',
                style: getTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: c.textSecondary,
                ),
              ),
              const Spacer(),
              if (controller.isExamMode.value) ...[
                Icon(Iconsax.clock, size: 14.sp,
                    color: controller.remainingSeconds.value < 60
                        ? const Color(0xFFDC2626)
                        : const Color(0xFF0F58BD)),
                SizedBox(width: 4.w),
                Text(
                  controller.timerText,
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: controller.remainingSeconds.value < 60
                        ? const Color(0xFFDC2626)
                        : const Color(0xFF0F58BD),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(9999.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6.h,
              backgroundColor: c.border,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF0F58BD)),
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  // ─── Category Badge ──────────────────────────────────────────────
  Widget _buildCategoryBadge() {
    final question = controller.currentQuestion!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0F58BD).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(9999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Iconsax.note_2, size: 12.sp, color: const Color(0xFF0F58BD)),
          SizedBox(width: 8.w),
          Text(
            question.category.name,
            style: getTextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F58BD),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Question Text ───────────────────────────────────────────────
  Widget _buildQuestionText(BuildContext context) {
    final c = context.appColors;
    final question = controller.currentQuestion!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (question.isMultipleChoice)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              'Select all that apply',
              style: getTextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: c.textSecondary,
              ),
            ),
          ),
        Text(
          question.questionPrompt,
          style: getTextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
            lineHeight: 1.375,
          ),
        ),
      ],
    );
  }

  // ─── Options ─────────────────────────────────────────────────────
  Widget _buildOptions(BuildContext context) {
    final c = context.appColors;
    final question = controller.currentQuestion!;
    final selectedKeys = controller.currentAnswers;

    return Column(
      children: question.options.map((option) {
        final isSelected = selectedKeys.contains(option.key);
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: GestureDetector(
            onTap: () => controller.selectOption(option.key),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF0F58BD).withValues(alpha: 0.05)
                    : c.cardBg,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF0F58BD)
                      : c.border,
                ),
              ),
              child: Row(
                children: [
                  _buildRadioCircle(isSelected, question.isMultipleChoice),
                  SizedBox(width: 10.w),
                  Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF0F58BD)
                          : c.tagBg,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      option.key,
                      style: getTextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : c.textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      option.text,
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? c.textPrimary
                            : c.textBody,
                        lineHeight: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRadioCircle(bool isSelected, bool isMultiple) {
    if (isMultiple) {
      return Container(
        width: 20.w,
        height: 20.w,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F58BD) : Colors.transparent,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF0F58BD)
                : const Color(0xFFCBD5E1),
            width: 2,
          ),
        ),
        child: isSelected
            ? Icon(Icons.check, size: 14.sp, color: Colors.white)
            : null,
      );
    }

    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? const Color(0xFF0F58BD) : Colors.transparent,
        border: Border.all(
          color:
              isSelected ? const Color(0xFF0F58BD) : const Color(0xFFCBD5E1),
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            )
          : null,
    );
  }

  // ─── Rationale ───────────────────────────────────────────────────
  Widget _buildRationale(BuildContext context) {
    final c = context.appColors;
    final question = controller.currentQuestion!;
    final selectedKeys = controller.currentAnswers;

    return Column(
      children: [
        // Main explanation
        if (question.explanationMain != null &&
            question.explanationMain!.isNotEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: c.tagBg,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: c.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Iconsax.info_circle,
                        size: 20.sp, color: const Color(0xFF0F58BD)),
                    SizedBox(width: 8.w),
                    Text(
                      'Explanation',
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F58BD),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  question.explanationMain!,
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: c.textBody,
                    lineHeight: 1.625,
                  ),
                ),
              ],
            ),
          ),
        // Per-option rationales for selected answers
        ...selectedKeys.map((key) {
          final rationale = question.getRationale(key);
          if (rationale == null || rationale.isEmpty) return const SizedBox.shrink();

          final option = question.options.firstWhere((o) => o.key == key);

          return Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFF059669).withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                    color: const Color(0xFF059669).withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFF059669),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          key,
                          style: getTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          option.text,
                          style: getTextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF059669),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    rationale,
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: c.textBody,
                      lineHeight: 1.625,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  // ─── Footer ──────────────────────────────────────────────────────
  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: SafeArea(
        top: false,
        child: Obx(() {
          final isLast = controller.isLastQuestion;
          final hasAnswered = controller.hasAnswered;

          if (isLast && hasAnswered) {
            final isSubmitting = controller.isSubmitting.value;
            return _buildButton(
              label: isSubmitting ? 'Submitting...' : 'Submit Answers',
              icon: Icons.check_circle_outline,
              onTap: controller.submitAnswers,
              enabled: !isSubmitting,
              isLoading: isSubmitting,
            );
          }

          return _buildButton(
            label: 'Next Question',
            icon: Icons.arrow_forward,
            onTap: controller.nextQuestion,
            enabled: hasAnswered,
          );
        }),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF0F58BD) : const Color(0xFFCBD5E1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) ...[
              SizedBox(
                width: 20.w,
                height: 20.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 10.w),
            ],
            Text(
              label,
              style: getTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            if (!isLoading) ...[
              SizedBox(width: 8.w),
              Icon(icon, size: 24.sp, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }

  void _confirmExit(BuildContext context) {
    final c = context.appColors;
    Get.dialog(
      AlertDialog(
        backgroundColor: c.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          controller.isExamMode.value ? 'Leave Exam?' : 'Leave Quiz?',
          style: getTextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
        ),
        content: Text(
          controller.isExamMode.value
              ? 'Your progress is saved. You can resume this exam anytime from the home screen.'
              : 'Your progress will be lost if you leave now.',
          style: getTextStyle(
            fontSize: 14,
            color: c.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Continue',
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F58BD),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // close dialog
              Get.back(); // leave quiz
            },
            child: Text(
              'Leave',
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFDC2626),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
