import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../controller/quiz_controller.dart';
import '../../model/question_review_model.dart';

class QuestionReviewScreen extends GetView<QuizController> {
  const QuestionReviewScreen({super.key});

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
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios,
                size: 22.sp, color: const Color(0xFF0F58BD)),
          ),
          centerTitle: true,
          title: Text(
            'Answer Review',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
        ),
        body: Obx(() {
          final isLoading = controller.isLoadingReview.value;
          final review = controller.questionReview.value;

          if (isLoading || review == null) {
            return _buildSkeleton();
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusBadge(context, review),
                SizedBox(height: 16.h),
                _buildQuestionCard(context, review),
                SizedBox(height: 16.h),
                _buildOptionsSection(context, review),
                SizedBox(height: 16.h),
                _buildExplanationCard(context, review),
                SizedBox(height: 16.h),
                _buildRationalesSection(context, review),
                SizedBox(height: 24.h),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context, QuestionReviewModel review) {
    final c = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCorrect = review.isCorrect == true;
    final isAnswered = review.selectedAnswers.isNotEmpty;
    final color = !isAnswered
        ? c.textSecondary
        : isCorrect
            ? const Color(0xFF07883B)
            : const Color(0xFFEF4444);
    final bgColor = !isAnswered
        ? c.tagBg
        : isCorrect
            ? (isDark ? const Color(0xFF0A2E1A) : const Color(0xFFD1FAE5))
            : (isDark ? const Color(0xFF2A1515) : const Color(0xFFFEE2E2));
    final icon = !isAnswered
        ? Icons.help_outline_rounded
        : isCorrect
            ? Icons.check_circle_rounded
            : Icons.cancel_rounded;
    final label = !isAnswered
        ? 'Not Answered'
        : isCorrect
            ? 'Correct'
            : 'Incorrect';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24.sp, color: color),
          SizedBox(width: 10.w),
          Text(
            'Question ${review.questionNumber} · $label',
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, QuestionReviewModel review) {
    final c = context.appColors;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: c.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: [
              if (review.category != null)
                _buildChip(review.category!.name, const Color(0xFF0F58BD)),
              if (review.topic != null)
                _buildChip(review.topic!.name, const Color(0xFF7E22CE)),
              if (review.difficulty != null)
                _buildChip(
                    review.difficulty!.name, const Color(0xFFB45309)),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            review.questionPrompt,
            style: getTextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: c.textPrimary,
              lineHeight: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: getTextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _buildOptionsSection(BuildContext context, QuestionReviewModel review) {
    final c = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Options',
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
        ),
        SizedBox(height: 10.h),
        ...review.options.map((option) {
          final isCorrect = review.correctAnswers.contains(option.key);
          final isSelected = review.selectedAnswers.contains(option.key);
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: _buildOptionTile(
              context: context,
              option: option,
              isCorrect: isCorrect,
              isSelected: isSelected,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required ReviewOption option,
    required bool isCorrect,
    required bool isSelected,
  }) {
    final c = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color borderColor;
    Color bgColor;
    Color iconColor;
    IconData? trailingIcon;
    String? label;

    if (isCorrect) {
      borderColor = const Color(0xFF07883B);
      bgColor = isDark ? const Color(0xFF0A2E1A) : const Color(0xFFD1FAE5);
      iconColor = const Color(0xFF07883B);
      trailingIcon = Icons.check_circle_rounded;
      label = isSelected ? 'Your answer · Correct' : 'Correct answer';
    } else if (isSelected) {
      borderColor = const Color(0xFFEF4444);
      bgColor = isDark ? const Color(0xFF2A1515) : const Color(0xFFFEE2E2);
      iconColor = const Color(0xFFEF4444);
      trailingIcon = Icons.cancel_rounded;
      label = 'Your answer · Incorrect';
    } else {
      borderColor = c.border;
      bgColor = c.cardBg;
      iconColor = c.textSecondary;
      trailingIcon = null;
      label = null;
    }

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              option.key,
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: iconColor,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.text,
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: c.textPrimary,
                  ),
                ),
                if (label != null) ...[
                  SizedBox(height: 4.h),
                  Text(
                    label,
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: iconColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailingIcon != null) ...[
            SizedBox(width: 8.w),
            Icon(trailingIcon, size: 22.sp, color: iconColor),
          ],
        ],
      ),
    );
  }

  Widget _buildExplanationCard(BuildContext context, QuestionReviewModel review) {
    final c = context.appColors;
    if (review.explanationMain.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0F58BD).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border(
          left: BorderSide(color: const Color(0xFF0F58BD), width: 4.w),
        ),
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
            review.explanationMain,
            style: getTextStyle(
              fontSize: 14,
              color: c.textPrimary,
              lineHeight: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRationalesSection(BuildContext context, QuestionReviewModel review) {
    final c = context.appColors;
    final rationales = review.options
        .map((o) {
          final text = review.getRationale(o.key);
          return text != null && text.isNotEmpty ? MapEntry(o.key, text) : null;
        })
        .whereType<MapEntry<String, String>>()
        .toList();

    if (rationales.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rationales',
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: c.textPrimary,
          ),
        ),
        SizedBox(height: 10.h),
        ...rationales.map((entry) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: c.cardBg,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: c.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Option ${entry.key}',
                      style: getTextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F58BD),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      entry.value,
                      style: getTextStyle(
                        fontSize: 13,
                        color: c.textBody,
                        lineHeight: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Bone(
              width: double.infinity,
              height: 48.h,
              borderRadius: BorderRadius.circular(12.r),
            ),
            SizedBox(height: 16.h),
            Bone(
              width: double.infinity,
              height: 120.h,
              borderRadius: BorderRadius.circular(12.r),
            ),
            SizedBox(height: 16.h),
            ...List.generate(
              4,
              (_) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Bone(
                  width: double.infinity,
                  height: 64.h,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
