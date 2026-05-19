import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/common/widgets/login_required_dialog.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../../../routes/app_routes.dart';
import '../../controller/library_controller.dart';
import '../../model/library_home_model.dart';

class SavedTopicsScreen extends StatefulWidget {
  const SavedTopicsScreen({super.key});

  @override
  State<SavedTopicsScreen> createState() => _SavedTopicsScreenState();
}

class _SavedTopicsScreenState extends State<SavedTopicsScreen> {
  final LibraryController _controller = Get.find<LibraryController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.savedSearchQuery.value = '';
    _controller.savedCategoryId.value = null;
    _controller.savedMaterials.clear();
    _controller.fetchSavedMaterials();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _controller.loadMoreSaved();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios,
                size: 22.sp, color: const Color(0xFF0F58BD)),
          ),
          title: Text(
            'Saved Topics',
            style: getTextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
        ),
        body: Column(
          children: [
            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                        onChanged: _controller.onSavedSearchChanged,
                        style: getTextStyle(
                            fontSize: 16, color: c.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Search saved topics',
                          hintStyle: getTextStyle(
                            fontSize: 16,
                            color: c.textHint,
                          ),
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
            // Category filter tabs
            Obx(() {
              final categories = _controller.categories;
              final selectedId = _controller.savedCategoryId.value;

              return SizedBox(
                height: 52.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  itemCount: categories.length + 1,
                  separatorBuilder: (_, __) => SizedBox(width: 8.w),
                  itemBuilder: (context, i) {
                    final isAll = i == 0;
                    final isActive = isAll
                        ? selectedId == null
                        : selectedId == categories[i - 1].id;
                    final label =
                        isAll ? 'All Topics' : categories[i - 1].name;

                    return GestureDetector(
                      onTap: () => _controller.onSavedCategoryChanged(
                        isAll ? null : categories[i - 1].id,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF0F58BD)
                              : c.cardBg,
                          borderRadius: BorderRadius.circular(9999),
                          border: isActive
                              ? null
                              : Border.all(color: c.border),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          label,
                          style: getTextStyle(
                            fontSize: 14,
                            fontWeight:
                                isActive ? FontWeight.w700 : FontWeight.w500,
                            color: isActive
                                ? Colors.white
                                : c.textPrimary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
            SizedBox(height: 8.h),
            // Items list
            Expanded(
              child: Obx(() {
                final isLoading = _controller.isLoadingSaved.value;
                final materials = _controller.savedMaterials;

                if (isLoading && materials.isEmpty) {
                  return Skeletonizer(
                    enabled: true,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: 5,
                      separatorBuilder: (_, __) => SizedBox(height: 4.h),
                      itemBuilder: (_, __) => Container(
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: c.cardBg,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Bone(
                                width: 56.w,
                                height: 56.w,
                                borderRadius: BorderRadius.circular(8.r)),
                            SizedBox(width: 12.w),
                            const Expanded(child: Bone.multiText(lines: 2)),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                if (materials.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Iconsax.book_1,
                            size: 60.sp, color: c.textHint),
                        SizedBox(height: 8.h),
                        Text(
                          'No saved topics found',
                          style: getTextStyle(
                            fontSize: 14,
                            color: c.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => _controller.fetchSavedMaterials(),
                  child: ListView.separated(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                    itemCount: materials.length,
                    separatorBuilder: (_, __) => SizedBox(height: 4.h),
                    itemBuilder: (_, index) =>
                        _SavedTopicTile(item: materials[index]),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedTopicTile extends StatelessWidget {
  final StudyGuideItem item;

  const _SavedTopicTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
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
          arguments: {'materialId': item.id},
        );
      },
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: c.cardBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: c.border),
        ),
        child: Row(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                color: const Color(0xFF0F58BD).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: Icon(Iconsax.bookmark_2,
                  size: 24.sp, color: const Color(0xFF0F58BD)),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      if (item.category != null)
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              item.category!.name,
                              style: getTextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1D4ED8),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      if (item.category != null) SizedBox(width: 8.w),
                      if (item.pageCount != null)
                        Text(
                          '${item.pageCount} pages',
                          style: getTextStyle(
                            fontSize: 12,
                            color: c.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Iconsax.arrow_right_3,
                size: 24.sp, color: c.border),
          ],
        ),
      ),
    );
  }
}
