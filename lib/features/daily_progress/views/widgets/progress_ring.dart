import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';

class ProgressRing extends StatelessWidget {
  final int answered;
  final int goal;
  final double progress;
  final String message;
  final bool hasActiveSession;
  final VoidCallback? onResume;

  const ProgressRing({
    super.key,
    required this.answered,
    required this.goal,
    required this.progress,
    required this.message,
    this.hasActiveSession = false,
    this.onResume,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      width: double.infinity,
      color: c.cardBg,
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: Column(
        children: [
          // Circular progress
          SizedBox(
            width: 192.w,
            height: 192.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 192.w,
                  height: 192.w,
                  child: CircularProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    strokeWidth: 12.w,
                    backgroundColor: c.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF0F58BD),
                    ),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$answered',
                      style: getTextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F58BD),
                      ),
                    ),
                    Text(
                      'of $goal',
                      style: getTextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Questions Answered',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
          if (message.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Text(
                message,
                style: getTextStyle(
                  fontSize: 14,
                  color: c.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          if (hasActiveSession) ...[
            SizedBox(height: 24.h),
            // Resume Practice button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35.w),
              child: GestureDetector(
                onTap: onResume,
                child: Container(
                  width: double.infinity,
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A2540),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        size: 24.sp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Resume Practice',
                        style: getTextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.arrow_forward,
                        size: 14.sp,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
