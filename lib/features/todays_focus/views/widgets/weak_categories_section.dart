import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../model/todays_focus_model.dart';

class WeakCategoriesSection extends StatelessWidget {
  final List<WeakCategoryItem> categories;

  const WeakCategoriesSection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Column(
      children: [
        // Header
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Weak Categories',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        ...categories.map((cat) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: _WeakCategoryCard(category: cat),
            )),
      ],
    );
  }
}

class _WeakCategoryCard extends StatelessWidget {
  final WeakCategoryItem category;

  const _WeakCategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final isHighPriority =
        category.priority.toLowerCase().contains('high');
    final progressColor =
        isHighPriority ? const Color(0xFFF97316) : const Color(0xFF0F58BD);

    String subtitle = category.priority;
    if (category.statusText.isNotEmpty) {
      subtitle += ' \u2022 ${category.statusText}';
    }
    if (category.lastActiveDays > 0) {
      subtitle += ' \u2022 Last active ${category.lastActiveDays}d ago';
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: const Color(0xFF0F58BD).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Iconsax.book,
                size: 24.sp, color: const Color(0xFF0F58BD)),
          ),
          SizedBox(width: 12.w),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.categoryName,
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: getTextStyle(
                    fontSize: 12,
                    color: c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Percent + mini progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${category.accuracyRate.round()}%',
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              SizedBox(
                width: 70.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9999),
                  child: LinearProgressIndicator(
                    value: category.accuracyRate / 100,
                    minHeight: 6.h,
                    backgroundColor: c.tagBg,
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
