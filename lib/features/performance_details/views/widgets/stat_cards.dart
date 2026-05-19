import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';

class StatCards extends StatelessWidget {
  final String timePerQuestion;
  final String timeImprovement;
  final String studyHours;
  final String studyHoursChange;

  const StatCards({
    super.key,
    required this.timePerQuestion,
    required this.timeImprovement,
    required this.studyHours,
    required this.studyHoursChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Iconsax.timer_1,
            iconColor: const Color(0xFFF97316),
            label: 'Time / Question',
            value: timePerQuestion,
            change: timeImprovement,
            changeIcon: Iconsax.arrow_down,
            changeColor: const Color(0xFF10B981),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _StatCard(
            icon: Iconsax.book,
            iconColor: const Color(0xFF3B82F6),
            label: 'Study Hours',
            value: studyHours,
            change: studyHoursChange,
            changeIcon: Iconsax.arrow_up,
            changeColor: const Color(0xFF10B981),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String change;
  final IconData changeIcon;
  final Color changeColor;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.change,
    required this.changeIcon,
    required this.changeColor,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20.sp, color: iconColor),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  label,
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: c.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: getTextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(changeIcon, size: 14.sp, color: changeColor),
              SizedBox(width: 4.w),
              Flexible(
                child: Text(
                  change,
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: changeColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
