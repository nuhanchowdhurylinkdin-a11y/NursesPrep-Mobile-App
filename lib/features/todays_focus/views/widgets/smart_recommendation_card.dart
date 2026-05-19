import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common/styles/global_text_style.dart';

class SmartRecommendationCard extends StatelessWidget {
  final String title;
  final String description;
  final int questionCount;
  final VoidCallback? onTap;

  const SmartRecommendationCard({
    super.key,
    required this.title,
    required this.description,
    this.questionCount = 20,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F58BD),
        borderRadius: BorderRadius.circular(16.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -32.h,
            right: -32.w,
            child: Container(
              width: 128.w,
              height: 128.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -32.h,
            left: -32.w,
            child: Container(
              width: 128.w,
              height: 128.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.1),
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label
                Row(
                  children: [
                    Icon(
                      Iconsax.lamp_on,
                      size: 24.sp,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Smart Recommendation',
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                // Title
                Text(
                  title,
                  style: getTextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                // Description
                Text(
                  description,
                  style: getTextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                SizedBox(height: 20.h),
                // Button
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: double.infinity,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.play_circle,
                          size: 24.sp,
                          color: const Color(0xFF0F58BD),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Start $questionCount-Question Quiz',
                          style: getTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F58BD),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
