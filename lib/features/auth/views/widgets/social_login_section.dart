import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';

class SocialLoginSection extends StatelessWidget {
  final VoidCallback? onGoogleTap;
  final VoidCallback? onAppleTap;

  const SocialLoginSection({
    super.key,
    this.onGoogleTap,
    this.onAppleTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Column(
      children: [
        // Divider with text
        Row(
          children: [
            Expanded(
              child: Divider(color: c.border, height: 1.h),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Or continue with',
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: c.textSecondary,
                ),
              ),
            ),
            Expanded(
              child: Divider(color: c.border, height: 1.h),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        // Google
        _SocialButton(
          label: 'Sign in with Google',
          iconPath: 'assets/icons/google.svg',
          onTap: onGoogleTap,
        ),
        SizedBox(height: 12.h),
        _SocialButton(
          label: 'Sign in with Apple',
          iconPath: 'assets/icons/apple.svg',
          onTap: onAppleTap,
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback? onTap;

  const _SocialButton({
    required this.label,
    required this.iconPath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54.h,
        decoration: BoxDecoration(
          color: c.cardBg,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: c.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 20.w,
              height: 20.w,
            ),
            SizedBox(width: 12.w),
            Text(
              label,
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: c.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
