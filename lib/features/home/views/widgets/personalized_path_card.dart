import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';

class PersonalizedPathCard extends StatelessWidget {
  final VoidCallback? onTap;

  const PersonalizedPathCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final isDark = context.isDark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: isDark ? c.cardBg : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: isDark ? c.border : const Color(0xFFDBEAFE)),
      ),
      child: Row(
        children: [
          // Icon circle
          Container(
            width: 48.w,
            height: 48.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF0F58BD),
            ),
            child: Icon(
              Iconsax.routing,
              color: Colors.white,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personalized Path',
                  style: getTextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F58BD),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Optimize Today's Study",
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.cardBg,
              border: Border.all(color: isDark ? c.border : const Color(0xFFDBEAFE)),
            ),
            child: Icon(
              Iconsax.arrow_circle_right,
              color: const Color(0xFF0F58BD),
              size: 18.sp,
            ),
          ),
        ],
      ),
    ),
    );
  }
}
