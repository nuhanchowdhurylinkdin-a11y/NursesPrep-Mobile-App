import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';

class NotificationFilterTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const NotificationFilterTabs({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: c.border,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          _buildTab('All Alerts', 0, c),
          _buildTab('Unread', 1, c),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index, AppColorsExtension c) {
    final isActive = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isActive ? c.cardBg : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: getTextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isActive
                  ? const Color(0xFF0F58BD)
                  : c.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
