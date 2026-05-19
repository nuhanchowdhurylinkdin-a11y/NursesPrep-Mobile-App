import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/styles/global_text_style.dart';

class MockQuestionCard extends StatelessWidget {
  const MockQuestionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.assignment, color: const Color(0xFF136DEC), size: 14.sp),
              SizedBox(width: 8.w),
              Text(
                'Question 42 of 150',
                style: getTextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(100.r),
            child: LinearProgressIndicator(
              value: 42 / 150,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF136DEC)),
              minHeight: 8.h,
            ),
          ),
          SizedBox(height: 20.h),
          // Skeleton text lines
          _skeletonLine(width: 1.0),
          SizedBox(height: 8.h),
          _skeletonLine(width: 0.83),
          SizedBox(height: 8.h),
          _skeletonLine(width: 0.66, height: 24.h),
          SizedBox(height: 24.h),
          // Radio option 1 (selected)
          _radioOption(selected: true, widthFraction: 0.7),
          SizedBox(height: 8.h),
          // Radio option 2
          _radioOption(selected: false, widthFraction: 0.46),
          SizedBox(height: 16.h),
          // Badge
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                border: Border.all(color: const Color(0xFFBBF7D0)),
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Text(
                'Detailed Rationale Included',
                style: getTextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF15803D),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _skeletonLine({required double width, double? height}) {
    return FractionallySizedBox(
      widthFactor: width,
      child: Container(
        height: height ?? 16.h,
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(4.r),
        ),
      ),
    );
  }

  Widget _radioOption({required bool selected, required double widthFraction}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF136DEC).withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: selected ? const Color(0xFF136DEC) : const Color(0xFFF1F5F9),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 16.w,
            height: 16.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? const Color(0xFF136DEC) : const Color(0xFFCBD5E1),
                width: 2,
              ),
            ),
            child: selected
                ? Center(
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF136DEC),
                      ),
                    ),
                  )
                : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: widthFraction,
              child: Container(
                height: 12.h,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF136DEC).withValues(alpha: 0.2)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
