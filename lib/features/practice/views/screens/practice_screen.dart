import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../../../routes/app_routes.dart';
import '../../../profile/controller/profile_controller.dart';
import '../../controller/practice_controller.dart';
import '../../model/practice_data_model.dart';

class PracticeScreen extends GetView<PracticeController> {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    final c = context.appColors;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: false,
          title: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.isPracticeMode
                        ? 'Unified Practice'
                        : 'Exam Mode',
                    style: getTextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                  ),
                  Text(
                    'NursePrep Pro',
                    style: getTextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F58BD),
                    ),
                  ),
                ],
              )),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Obx(() {
                final url = profileController.avatarUrl;
                return CircleAvatar(
                  radius: 20.r,
                  backgroundColor: c.border,
                  backgroundImage:
                      url.isNotEmpty ? NetworkImage(url) : null,
                  child: url.isEmpty
                      ? Icon(Iconsax.user,
                          size: 20.sp, color: c.textHint)
                      : null,
                );
              }),
            ),
          ],
        ),
        body: Obx(() => Skeletonizer(
              enabled: controller.isLoading.value,
              child: RefreshIndicator(
                onRefresh: controller.fetchData,
                color: const Color(0xFF0F58BD),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),
                        // Search bar (both modes)
                        _SearchBar(
                          onChanged: (val) =>
                              controller.searchQuery.value = val,
                        ),
                        SizedBox(height: 24.h),

                        if (controller.isPracticeMode) ...[
                          // Quick Start (practice mode only)
                          _buildQuickStart(context),
                          SizedBox(height: 32.h),
                        ],

                        // Explore Categories header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Explore Categories',
                              style: getTextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: c.textSecondary,
                              ),
                            ),
                            Text(
                              'View Stats',
                              style: getTextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F58BD),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        // Category list (filtered by search)
                        ...List.generate(
                          controller.filteredCategories.length,
                          (i) {
                            final cat = controller.filteredCategories[i];
                            final originalIndex =
                                controller.categories.indexOf(cat);
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: _CategoryTile(
                                category: cat,
                                index: originalIndex,
                                onTap: () {
                                  controller.selectCategory(cat.id);
                                  Get.toNamed(
                                      AppRoute.getTopicSelectionScreen());
                                },
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Widget _buildQuickStart(BuildContext context) {
    final c = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quick Start',
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: c.textSecondary,
              ),
            ),
            if (controller.isPracticeMode)
              Row(
                children: [
                  Text(
                    'Randomize',
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: c.textHint,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  SizedBox(
                    width: 40.w,
                    height: 20.h,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Switch(
                        value: controller.randomize.value,
                        onChanged: controller.toggleRandomize,
                        activeThumbColor: Colors.white,
                        activeTrackColor: const Color(0xFF0F58BD),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: c.border,
                      ),
                    ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16.h),
        // Card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(21.w),
          decoration: BoxDecoration(
            color: c.cardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: c.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.isPracticeMode) ...[
                // Difficulty label
                Text(
                  'Difficulty Level',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: c.textHint,
                  ),
                ),
                SizedBox(height: 12.h),
                // Difficulty tabs from API
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: c.tagBg,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: List.generate(controller.difficulties.length, (i) {
                      final isActive =
                          controller.selectedDifficultyIndex.value == i;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => controller.selectDifficulty(i),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            decoration: BoxDecoration(
                              color:
                                  isActive ? c.cardBg : Colors.transparent,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              controller.difficulties[i].levelName,
                              style: getTextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isActive
                                    ? const Color(0xFF0F58BD)
                                    : c.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: 20.h),
                // Question Count
                Text(
                  'Number of Questions',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: c.textHint,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: const Color(0xFF0F58BD),
                          inactiveTrackColor: c.border,
                          thumbColor: const Color(0xFF0F58BD),
                          overlayColor:
                              const Color(0xFF0F58BD).withValues(alpha: 0.1),
                          trackHeight: 4.h,
                          thumbShape: RoundSliderThumbShape(
                              enabledThumbRadius: 8.r),
                        ),
                        child: Slider(
                          value: controller.questionCount.value.toDouble(),
                          min: 1,
                          max: 150,
                          divisions: 149,
                          onChanged: (val) =>
                              controller.questionCount.value = val.round(),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      width: 48.w,
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                      decoration: BoxDecoration(
                        color: c.tagBg,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${controller.questionCount.value}',
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F58BD),
                        ),
                      ),
                    ),
                ],
              ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Search Bar ──────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const _SearchBar({this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: c.fieldBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: c.border),
      ),
      child: TextField(
        onChanged: onChanged,
        style: getTextStyle(
          fontSize: 14,
          color: c.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search topics, symptoms, or medications...',
          hintStyle: getTextStyle(
            fontSize: 14,
            color: c.textHint,
          ),
          prefixIcon: Icon(
            Iconsax.search_normal_1,
            size: 20.sp,
            color: c.textHint,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        ),
      ),
    );
  }
}

// ─── Category Tile ───────────────────────────────────────────────

// Icon/color sets for categories & topics
const _categoryIcons = [
  Iconsax.health,
  Iconsax.lovely,
  Iconsax.hospital,
  Iconsax.emoji_happy,
  Iconsax.danger,
  Iconsax.shield_tick,
];

const _categoryColors = [
  Color(0xFF0F58BD),
  Color(0xFF059669),
  Color(0xFF9333EA),
  Color(0xFFEA580C),
  Color(0xFFDC2626),
  Color(0xFF0284C7),
];

const _categoryBgColors = [
  Color(0xFFEFF6FF),
  Color(0xFFECFDF5),
  Color(0xFFFAF5FF),
  Color(0xFFFFF7ED),
  Color(0xFFFEF2F2),
  Color(0xFFF0F9FF),
];

class _CategoryTile extends StatelessWidget {
  final CategoryModel category;
  final int index;
  final VoidCallback? onTap;

  const _CategoryTile({
    required this.category,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final color = _categoryColors[index % _categoryColors.length];
    final bgColor = _categoryBgColors[index % _categoryBgColors.length];
    final icon = _categoryIcons[index % _categoryIcons.length];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: c.cardBg,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: c.border),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 24.sp, color: color),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                category.categoryName,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
            ),
            Icon(
              Iconsax.arrow_right_3,
              size: 20.sp,
              color: c.textHint,
            ),
          ],
        ),
      ),
    );
  }
}

