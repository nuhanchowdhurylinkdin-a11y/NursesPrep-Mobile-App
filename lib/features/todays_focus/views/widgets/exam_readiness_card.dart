import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';

class ExamReadinessCard extends StatelessWidget {
  final double readiness;
  final double change;
  final int totalQuestions;

  const ExamReadinessCard({
    super.key,
    required this.readiness,
    required this.change,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      width: double.infinity,
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
            'Exam Readiness',
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: c.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text(
                '${readiness.toInt()}%',
                style: getTextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
              SizedBox(width: 8.w),
              if (change != 0)
                Row(
                  children: [
                    Icon(
                      change > 0 ? Iconsax.trend_up : Iconsax.trend_down,
                      size: 14.sp,
                      color: change > 0
                          ? const Color(0xFF07883B)
                          : const Color(0xFFEF4444),
                    ),
                    Text(
                      '${change > 0 ? '+' : ''}${change % 1 == 0 ? change.toInt() : change}%',
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: change > 0
                            ? const Color(0xFF07883B)
                            : const Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Based on ${_formatNumber(totalQuestions)} questions',
            style: getTextStyle(
              fontSize: 12,
              color: c.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(number % 1000 == 0 ? 0 : 0)},${(number % 1000).toString().padLeft(3, '0')}';
    }
    return number.toString();
  }
}
