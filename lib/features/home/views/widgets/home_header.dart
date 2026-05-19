import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common/styles/global_text_style.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String userType;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar
        CircleAvatar(
          radius: 24.r,
          backgroundColor: const Color(0xFF1B3A5C),
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: 24.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, $userName',
                style: getTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                userType,
                style: getTextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF4DA3FF),
                ),
              ),
            ],
          ),
        ),
        // Notification icon
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Iconsax.notification,
            color: Colors.white,
            size: 22.sp,
          ),
        ),
      ],
    );
  }
}
