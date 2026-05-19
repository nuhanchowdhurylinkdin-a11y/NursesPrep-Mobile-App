import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../model/onboarding_model.dart';

class FeatureItemTile extends StatelessWidget {
  final OnboardingFeatureItem item;

  const FeatureItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: const Color(0xFF136DEC).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              item.icon,
              color: const Color(0xFF136DEC),
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D131B),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  item.subtitle,
                  style: getTextStyle(
                    fontSize: 14,
                    color: const Color(0xFF4C6C9A),
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
