import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';

class AdjustGoalCard extends StatelessWidget {
  final double sliderValue;
  final double sliderMin;
  final double sliderMax;
  final List<int> allowedOptions;
  final ValueChanged<double> onChanged;
  final VoidCallback onSave;
  final bool isSaving;

  const AdjustGoalCard({
    super.key,
    required this.sliderValue,
    required this.sliderMin,
    required this.sliderMax,
    required this.allowedOptions,
    required this.onChanged,
    required this.onSave,
    this.isSaving = false,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: c.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Iconsax.setting_2,
                size: 24.sp,
                color: const Color(0xFF0F58BD),
              ),
              SizedBox(width: 8.w),
              Text(
                'Adjust Daily Goal',
                style: getTextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Daily Questions label + value
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Questions',
                style: getTextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: c.textSecondary,
                ),
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: c.tagBg,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: c.borderSubtle),
                ),
                child: Text(
                  '${sliderValue.toInt()}',
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Slider
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFF0F58BD),
              inactiveTrackColor: c.borderSubtle,
              thumbColor: c.cardBg,
              overlayColor: const Color(0xFF0F58BD).withValues(alpha: 0.1),
              trackHeight: 6.h,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 12.r,
                elevation: 2,
              ),
            ),
            child: Slider(
              value: sliderValue,
              min: sliderMin,
              max: sliderMax,
              onChanged: onChanged,
            ),
          ),
          // Labels from allowed options
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: allowedOptions.map((option) {
                return Text(
                  '$option',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: c.textSecondary,
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20.h),
          // Save button
          GestureDetector(
            onTap: isSaving ? null : onSave,
            child: Container(
              width: double.infinity,
              height: 48.h,
              decoration: BoxDecoration(
                color: isSaving
                    ? const Color(0xFFCBD5E1)
                    : const Color(0xFF0F58BD),
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: isSaving
                  ? SizedBox(
                      width: 20.w,
                      height: 20.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Save Daily Goal',
                      style: getTextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
