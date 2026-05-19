import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/styles/global_text_style.dart';

class AnalyticsCard extends StatelessWidget {
  const AnalyticsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFF1F5F9)),
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
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Performance Score',
                    style: getTextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF94A3B8),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '88%',
                    style: getTextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D131B),
                    ),
                  ),
                ],
              ),
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.trending_up,
                  color: const Color(0xFF16A34A),
                  size: 24.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Bar chart
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 96.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _bar(0.40, 0.2),
                      _bar(0.60, 0.4),
                      _bar(0.85, 0.6),
                      _bar(0.70, 1.0),
                      _bar(0.95, 0.8),
                    ],
                  ),
                ),
                Divider(color: const Color(0xFFE2E8F0), height: 16.h),
                // Pharmacology row
                _progressRow('Pharmacology', 0.92, '92%', const Color(0xFF136DEC)),
                SizedBox(height: 8.h),
                // Pediatrics row
                _progressRow('Pediatrics', 0.64, '64%',
                    const Color(0xFF136DEC).withValues(alpha: 0.6)),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          // Warning banner
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBEB),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color(0xFFFEF3C7)),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: const Color(0xFFF59E0B), size: 18.sp),
                SizedBox(width: 8.w),
                Text(
                  'Review: Dosage Calculations',
                  style: getTextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF92400E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bar(double heightFraction, double opacity) {
    return Flexible(
      child: FractionallySizedBox(
        heightFactor: heightFraction,
        child: Container(
          width: 36.w,
          decoration: BoxDecoration(
            color: const Color(0xFF136DEC).withValues(alpha: opacity == 1.0 ? 1.0 : opacity),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ),
    );
  }

  Widget _progressRow(String label, double value, String percent, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: getTextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
              ),
            ),
            Text(
              percent,
              style: getTextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(100.r),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 4.h,
          ),
        ),
      ],
    );
  }
}
