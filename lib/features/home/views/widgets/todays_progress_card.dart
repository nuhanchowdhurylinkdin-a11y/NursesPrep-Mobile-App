import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';

class TodaysProgressCard extends StatelessWidget {
  final int questionsAnswered;
  final int dailyGoal;
  final int progressPercent;
  final VoidCallback? onTap;

  const TodaysProgressCard({
    super.key,
    required this.questionsAnswered,
    required this.dailyGoal,
    required this.progressPercent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Progress",
          style: getTextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: c.textSecondary,
          ),
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: c.cardBg,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: c.borderSubtle),
            ),
          child: Row(
            children: [
              // Circular progress
              SizedBox(
                width: 56.w,
                height: 56.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 56.w,
                      height: 56.w,
                      child: CircularProgressIndicator(
                        value: progressPercent / 100,
                        strokeWidth: 5.w,
                        backgroundColor: c.borderSubtle,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF0F58BD),
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Text(
                      '$progressPercent%',
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Question Goal',
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '$questionsAnswered of $dailyGoal questions answered',
                      style: getTextStyle(
                        fontSize: 12,
                        color: c.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Iconsax.arrow_right_3,
                size: 20.sp,
                color: c.textHint,
              ),
            ],
          ),
        ),
        ),
      ],
    );
  }
}
