import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/styles/global_text_style.dart';

class TopicFilterTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const TopicFilterTabs({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = ['All Topics', 'Saved', 'In Progress', 'Unread'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isActive = selectedIndex == i;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF0F58BD)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  tabs[i],
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight:
                        isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive
                        ? Colors.white
                        : const Color(0xFF374151),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
