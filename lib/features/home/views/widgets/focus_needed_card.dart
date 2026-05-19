import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';

class FocusNeededCard extends StatelessWidget {
  final String topic;
  final double score;
  final double threshold;
  final double change;

  const FocusNeededCard({
    super.key,
    required this.topic,
    required this.score,
    required this.threshold,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;

    return Container(
      width: double.infinity,
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
              Icon(
                Iconsax.warning_2,
                size: 16.sp,
                color: const Color(0xFFE53935),
              ),
              SizedBox(width: 6.w),
              Text(
                'Focus Needed',
                style: getTextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFE53935),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic,
                      style: getTextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: c.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Average score: ${score.toInt()}% (Threshold ${threshold.toInt()}%)',
                      style: getTextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: c.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '↘${change.toInt()}%',
                style: getTextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFE53935),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
