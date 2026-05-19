import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/login_required_dialog.dart';
import '../../../../core/common/widgets/staggered_fade_in.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../../../routes/app_routes.dart';
import '../../controller/library_controller.dart';
import '../../model/library_home_model.dart';
import '../widgets/topic_filter_tabs.dart';

class LibraryScreen extends GetView<LibraryController> {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() {
        final isTopicView = controller.selectedCategoryIndex.value != null;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (child, animation) {
            final isForward = child.key == const ValueKey('topics');
            final offset = isForward
                ? Tween<Offset>(
                    begin: const Offset(1.0, 0.0), end: Offset.zero)
                : Tween<Offset>(
                    begin: const Offset(-1.0, 0.0), end: Offset.zero);
            return SlideTransition(
              position: offset.animate(animation),
              child: child,
            );
          },
          child: isTopicView
              ? _TopicListView(key: const ValueKey('topics'))
              : _CategoriesView(key: const ValueKey('categories')),
        );
      }),
    );
  }
}

// ─── Categories Main View ───
class _CategoriesView extends StatelessWidget {
  const _CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LibraryController>();
    final c = context.appColors;
    return Column(
      children: [
        // Header
        Container(
          color: c.cardBg,
          padding: EdgeInsets.fromLTRB(16.w, 50.h, 16.w, 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Library',
                style: getTextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    Get.toNamed(AppRoute.getNotificationsScreen()),
                child: Icon(
                  Iconsax.notification,
                  size: 24.sp,
                  color: c.textPrimary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            final isLoading = controller.isLoading.value;

            return RefreshIndicator(
              onRefresh: controller.fetchLibraryHome,
              color: const Color(0xFF0F58BD),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                child: Skeletonizer(
                  enabled: isLoading,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search
                      StaggeredFadeIn(
                        index: 0,
                        enabled: !isLoading,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 12.h),
                          child: GestureDetector(
                            onTap: () =>
                                Get.toNamed(AppRoute.getLibrarySearchScreen()),
                            child: Container(
                              height: 48.h,
                              decoration: BoxDecoration(
                                color: c.fieldBg,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 12.w),
                                  Icon(Iconsax.search_normal_1,
                                      size: 24.sp,
                                      color: c.textSecondary),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Search pharmacology, symptoms...',
                                    style: getTextStyle(
                                      fontSize: 16,
                                      color: c.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Saved Topics card
                      StaggeredFadeIn(
                        index: 1,
                        enabled: !isLoading,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: GestureDetector(
                            onTap: () =>
                                Get.toNamed(AppRoute.getSavedTopicsScreen()),
                            child: Container(
                              padding: EdgeInsets.all(14.w),
                              decoration: BoxDecoration(
                                color: c.cardBg,
                                borderRadius: BorderRadius.circular(8.r),
                                border:
                                    Border.all(color: c.borderSubtle),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40.w,
                                    height: 40.w,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0F58BD)
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(Iconsax.bookmark,
                                        size: 24.sp,
                                        color: const Color(0xFF0F58BD)),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Saved Topics',
                                            style: getTextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: c.textPrimary)),
                                        Text(
                                            '${controller.totalBookmarked} items bookmarked',
                                            style: getTextStyle(
                                                fontSize: 14,
                                                color: c.textSecondary)),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.chevron_right,
                                      size: 24.sp,
                                      color: c.textHint),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // Medical Categories
                      StaggeredFadeIn(
                        index: 2,
                        enabled: !isLoading,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text('Medical Categories',
                              style: getTextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: c.textPrimary)),
                        ),
                      ),
                      12.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12.w,
                            mainAxisSpacing: 12.h,
                            childAspectRatio: 173.w / 110.h,
                          ),
                          itemCount: controller.categories.length,
                          itemBuilder: (context, i) {
                            final cat = controller.categories[i];
                            return StaggeredFadeIn(
                              index: 3 + i,
                              enabled: !isLoading,
                              stagger: const Duration(milliseconds: 70),
                              child: _CategoryGridCard(
                                name: cat.name,
                                materialCount: cat.totalMaterials,
                                onTap: () => controller.selectCategory(i),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // Study Guides
                      if (controller.studyGuides.isNotEmpty) ...[
                        StaggeredFadeIn(
                          index: 3 + controller.categories.length,
                          enabled: !isLoading,
                          stagger: const Duration(milliseconds: 70),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text('Study Guides',
                                style: getTextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: c.textPrimary)),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        ...controller.studyGuides.asMap().entries.map(
                              (entry) => StaggeredFadeIn(
                                index: 4 +
                                    controller.categories.length +
                                    entry.key,
                                enabled: !isLoading,
                                stagger: const Duration(milliseconds: 70),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      16.w, 0, 16.w, 8.h),
                                  child: _StudyGuideRow(guide: entry.value),
                                ),
                              ),
                            ),
                      ],
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _CategoryGridCard extends StatelessWidget {
  final String name;
  final int materialCount;
  final VoidCallback onTap;

  const _CategoryGridCard({
    required this.name,
    required this.materialCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: c.cardBg,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: c.borderSubtle),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 17.w),
              child: Container(
                width: 40.w,
                height: 46.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F58BD).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.center,
                child: Icon(Iconsax.book_1,
                    size: 24.sp, color: const Color(0xFF0F58BD)),
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.only(left: 17.w, right: 8.w),
              child: Text(
                name,
                style: getTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 17.w),
              child: Text(
                '$materialCount materials',
                style: getTextStyle(
                  fontSize: 12,
                  color: c.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StudyGuideRow extends StatelessWidget {
  final StudyGuideItem guide;

  const _StudyGuideRow({required this.guide});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final isPdf = guide.isPdf;
    final iconColor = isPdf ? const Color(0xFFDC2626) : const Color(0xFF2563EB);
    final iconBgColor =
        isPdf ? const Color(0xFFFEF2F2) : const Color(0xFFEFF6FF);

    return GestureDetector(
      onTap: () {
        if (StorageService.isGuest) {
          LoginRequiredDialog.show(
            message: 'Log in to read full study materials and PDFs.',
          );
          return;
        }
        Get.toNamed(
          AppRoute.getPdfViewerScreen(),
          arguments: {'materialId': guide.id},
        );
      },
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: c.cardBg,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: c.borderSubtle),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: Icon(
                isPdf ? Iconsax.document : Iconsax.note_text,
                size: 24.sp,
                color: iconColor,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(guide.title,
                      style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: c.textPrimary)),
                  SizedBox(height: 2.h),
                  Text(
                    _buildSubtitle(),
                    style: getTextStyle(
                        fontSize: 12, color: c.textSecondary),
                  ),
                ],
              ),
            ),
            // Badge
            if (guide.badgeLabel.isNotEmpty)
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F58BD).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  guide.badgeLabel,
                  style: getTextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F58BD),
                  ),
                ),
              ),
            SizedBox(width: 8.w),
            Icon(
              Icons.chevron_right,
              size: 24.sp,
              color: c.textHint,
            ),
          ],
        ),
      ),
    );
  }

  String _buildSubtitle() {
    final parts = <String>[];
    if (guide.category != null) parts.add(guide.category!.name);
    if (guide.pageCount != null) parts.add('${guide.pageCount} pages');
    if (guide.estimatedReadMinutes != null) {
      parts.add('${guide.estimatedReadMinutes} min read');
    }
    return parts.isNotEmpty ? parts.join(' • ') : guide.description;
  }
}

// ─── Topic List View (after selecting a category) ───
class _TopicListView extends StatelessWidget {
  const _TopicListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LibraryController>();
    final c = context.appColors;
    final cat = controller.selectedCategory!;

    return Column(
      children: [
        // Header
        Container(
          color: c.cardBg,
          padding: EdgeInsets.fromLTRB(16.w, 50.h, 16.w, 12.h),
          child: Row(
            children: [
              GestureDetector(
                onTap: controller.goBackToCategories,
                child: Icon(Icons.arrow_back_ios,
                    size: 22.sp, color: const Color(0xFF0F58BD)),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  cat.name,
                  style: getTextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        // Drag indicator
        Container(
          width: 40.w,
          height: 4.h,
          margin: EdgeInsets.only(top: 4.h, bottom: 8.h),
          decoration: BoxDecoration(
            color: c.border,
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: c.fieldBg,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 12.w),
                      Icon(Iconsax.search_normal_1,
                          size: 24.sp, color: c.textSecondary),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: TextField(
                          onChanged: controller.onSearchChanged,
                          style: getTextStyle(
                              fontSize: 14,
                              color: c.textPrimary),
                          decoration: InputDecoration(
                            hintText:
                                'Search ${cat.name.toLowerCase()} topics...',
                            hintStyle: getTextStyle(
                                fontSize: 14,
                                color: c.textSecondary),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              // Filter tabs
              Obx(() => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: TopicFilterTabs(
                      selectedIndex: controller.selectedTopicFilter.value,
                      onChanged: controller.selectTopicFilter,
                    ),
                  )),
              SizedBox(height: 16.h),
              // Materials list
              Expanded(
                child: Obx(() {
                  final isLoading = controller.isLoadingMaterials.value;
                  final materials = controller.categoryMaterials;

                  if (isLoading && materials.isEmpty) {
                    return Skeletonizer(
                      enabled: true,
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: 4,
                        separatorBuilder: (_, __) => SizedBox(height: 8.h),
                        itemBuilder: (_, __) => Container(
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            color: c.cardBg,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Bone(
                                  width: 40.w,
                                  height: 40.w,
                                  borderRadius:
                                      BorderRadius.circular(8.r)),
                              SizedBox(width: 12.w),
                              const Expanded(
                                  child: Bone.multiText(lines: 2)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  if (materials.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40.h),
                        child: Text(
                          'No materials found',
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: c.textHint,
                          ),
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.fetchCategoryMaterials,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()),
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                      itemCount: materials.length,
                      separatorBuilder: (_, __) => SizedBox(height: 8.h),
                      itemBuilder: (_, index) => StaggeredFadeIn(
                        index: index.clamp(0, 10),
                        stagger: const Duration(milliseconds: 60),
                        child: _StudyGuideRow(guide: materials[index]),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
