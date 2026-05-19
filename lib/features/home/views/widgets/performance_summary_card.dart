import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';

class PerformanceSummaryCard extends StatelessWidget {
  final double accuracy;
  final double accuracyChange;
  final int totalExams;
  final VoidCallback? onDetailsTap;

  const PerformanceSummaryCard({
    super.key,
    required this.accuracy,
    required this.accuracyChange,
    required this.totalExams,
    this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Performance Summary',
              style: getTextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: c.textSecondary,
              ),
            ),
            GestureDetector(
              onTap: onDetailsTap,
              child: Text(
                'Details',
                style: getTextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF0F58BD),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // Cards row
        Row(
          children: [
            // Accuracy card
            Expanded(
              child: _StatCard(
                icon: Iconsax.chart,
                label: 'Accuracy',
                value: '${accuracy.toInt()}%',
                change: '+${accuracyChange.toInt()}%',
                changeColor: const Color(0xFF4CAF50),
              ),
            ),
            SizedBox(width: 12.w),
            // Exams card
            Expanded(
              child: _StatCard(
                icon: Iconsax.document_text,
                label: 'Exams',
                value: '$totalExams',
                suffix: 'total',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? change;
  final Color? changeColor;
  final String? suffix;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.change,
    this.changeColor,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: c.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14.sp, color: c.textHint),
              SizedBox(width: 6.w),
              Text(
                label,
                style: getTextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: c.textBody,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: getTextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
              if (suffix != null) ...[
                SizedBox(width: 4.w),
                Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Text(
                    suffix!,
                    style: getTextStyle(
                      fontSize: 10,
                      color: c.textHint,
                    ),
                  ),
                ),
              ],
              if (change != null) ...[
                SizedBox(width: 6.w),
                Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: Text(
                    '↗$change',
                    style: getTextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: changeColor ?? const Color(0xFF4CAF50),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
