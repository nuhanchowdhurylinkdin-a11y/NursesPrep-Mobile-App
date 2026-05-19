import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';

class LicenseTypeSelector extends StatelessWidget {
  final RxInt selectedIndex;

  const LicenseTypeSelector({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Column(
      children: [
        Text(
          'Select License Type',
          style: getTextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: c.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => Container(
            height: 48.h,
            decoration: BoxDecoration(
              color: context.isDark ? c.fieldBg : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                _tab('LPN', 0, c, context.isDark),
                _tab('RN', 1, c, context.isDark),
              ],
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          'This determines your study curriculum',
          style: getTextStyle(
            fontSize: 12,
            color: c.textHint,
          ),
        ),
      ],
    );
  }

  Widget _tab(String label, int index, AppColorsExtension c, bool isDark) {
    final isSelected = selectedIndex.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => selectedIndex.value = index,
        child: Container(
          height: 40.h,
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? c.tagBg : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: c.shadow,
                      blurRadius: 4.r,
                      offset: Offset(0, 2.h),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isSelected
                  ? const Color(0xFF136DEC)
                  : c.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
