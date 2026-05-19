import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/styles/global_text_style.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showIcon;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showIcon) ...[
          SizedBox(height: 32.h),
          Icon(
            Icons.medical_services,
            color: const Color(0xFF0F58BD),
            size: 48.sp,
          ),
          SizedBox(height: 16.h),
        ],
        Text(
          title,
          textAlign: TextAlign.center,
          style: getTextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0D131B),
          ),
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: getTextStyle(
              fontSize: 16,
              color: const Color(0xFF4C6C9A),
            ),
          ),
        ),
      ],
    );
  }
}
