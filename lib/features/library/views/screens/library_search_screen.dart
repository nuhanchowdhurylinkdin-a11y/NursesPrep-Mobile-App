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
import '../../model/library_search_model.dart';

class LibrarySearchScreen extends StatefulWidget {
  const LibrarySearchScreen({super.key});

  @override
  State<LibrarySearchScreen> createState() => _LibrarySearchScreenState();
}

class _LibrarySearchScreenState extends State<LibrarySearchScreen> {
  final LibraryController _controller = Get.find<LibraryController>();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.initSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _hasQuery => _searchController.text.trim().isNotEmpty;

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
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.arrow_back_ios,
                size: 22.sp, color: const Color(0xFF0F58BD)),
          ),
          centerTitle: true,
          title: Text(
            'Library Search',
            style: getTextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Center(
                  child: Text(
                    'Cancel',
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F58BD),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Search input
            Container(
              color: c.cardBg,
              padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
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
                        controller: _searchController,
                        autofocus: true,
                        onChanged: (val) {
                          setState(() {});
                          _controller.onLibrarySearchChanged(val.trim());
                        },
                        style: getTextStyle(
                          fontSize: 16,
                          color: c.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search topics, guides, questions...',
                          hintStyle: getTextStyle(
                            fontSize: 16,
                            color: c.textHint,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 14.h),
                        ),
                      ),
                    ),
                    if (_hasQuery)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() {});
                          _controller.onLibrarySearchChanged('');
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 12.w),
                          child: Icon(Icons.cancel,
                              size: 20.sp, color: c.textHint),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Content
            Expanded(
              child: Obx(() {
                final isLoading = _controller.isLoadingSearch.value;
                final data = _controller.searchData.value;

                if (isLoading && data == null) {
                  return Skeletonizer(
                    enabled: true,
                    child: ListView(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      children: [
                        const Bone.text(words: 2),
                        SizedBox(height: 12.h),
                        ...List.generate(
                          3,
                          (_) => Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Container(
                              padding: EdgeInsets.all(14.w),
                              decoration: BoxDecoration(
                                color: c.cardBg,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                children: [
                                  Bone(
                                      width: 48.w,
                                      height: 48.w,
                                      borderRadius:
                                          BorderRadius.circular(12.r)),
                                  SizedBox(width: 12.w),
                                  const Expanded(
                                      child: Bone.multiText(lines: 2)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (_hasQuery) {
                  return _buildSearchResults(data);
                }

                return _buildDefaultContent(data);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultContent(LibrarySearchModel? data) {
    final c = context.appColors;
    final recentSearches = data?.recentSearches ?? [];
    final trendingTopics = data?.trendingTopics ?? [];

    return RefreshIndicator(
      onRefresh: () => _controller.fetchSearchResults(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recent Searches
            if (recentSearches.isNotEmpty) ...[
              Text(
                'Recent Searches',
                style: getTextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: recentSearches.map((item) {
                  return GestureDetector(
                    onTap: () {
                      _searchController.text = item.query;
                      setState(() {});
                      _controller.onLibrarySearchChanged(item.query);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: c.tagBg,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Iconsax.clock,
                              size: 16.sp,
                              color: c.textSecondary),
                          SizedBox(width: 6.w),
                          Text(
                            item.query,
                            style: getTextStyle(
                              fontSize: 14,
                              color: c.textBody,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 24.h),
            ],
            // Trending Topics
            if (trendingTopics.isNotEmpty) ...[
              Text(
                'Trending Topics',
                style: getTextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: c.textPrimary,
                ),
              ),
              SizedBox(height: 12.h),
              ...trendingTopics.map((topic) => Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: _TrendingTopicTile(topic: topic),
                  )),
            ],
            if (recentSearches.isEmpty && trendingTopics.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 60.h),
                  child: Column(
                    children: [
                      Icon(Iconsax.search_normal_1,
                          size: 48.sp, color: c.textHint),
                      SizedBox(height: 12.h),
                      Text(
                        'Search for topics, guides, or questions',
                        style: getTextStyle(
                          fontSize: 14,
                          color: c.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(LibrarySearchModel? data) {
    final c = context.appColors;
    if (data == null) return const SizedBox.shrink();

    final items = data.materials;

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.search_normal_1,
                size: 48.sp, color: c.textHint),
            SizedBox(height: 12.h),
            Text(
              'No results found',
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: c.textSecondary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Try a different search term',
              style: getTextStyle(
                fontSize: 14,
                color: c.textHint,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _controller.fetchSearchResults(),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        itemCount: items.length,
        separatorBuilder: (_, _) => SizedBox(height: 8.h),
        itemBuilder: (_, index) => _SearchResultTile(item: items[index]),
      ),
    );
  }
}

class _TrendingTopicTile extends StatelessWidget {
  final TrendingTopicItem topic;

  const _TrendingTopicTile({required this.topic});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: c.cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: c.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: const Color(0xFF0F58BD).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
            child: Icon(Iconsax.trend_up,
                size: 24.sp, color: const Color(0xFF0F58BD)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.title,
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  topic.subtitle,
                  style: getTextStyle(
                    fontSize: 13,
                    color: c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Iconsax.arrow_right_3,
              size: 20.sp, color: c.border),
        ],
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final StudyGuideItem item;

  const _SearchResultTile({required this.item});

  Color get _badgeColor {
    switch (item.itemType) {
      case 'topic':
        return const Color(0xFF1D4ED8);
      case 'guide':
        return const Color(0xFF15803D);
      case 'question':
        return const Color(0xFFB45309);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Color get _badgeBgColor {
    switch (item.itemType) {
      case 'topic':
        return const Color(0xFFEFF6FF);
      case 'guide':
        return const Color(0xFFF0FDF4);
      case 'question':
        return const Color(0xFFFFFBEB);
      default:
        return const Color(0xFFF3F4F6);
    }
  }

  IconData get _icon {
    switch (item.itemType) {
      case 'topic':
        return Iconsax.book_1;
      case 'guide':
        return Iconsax.document_text;
      case 'question':
        return Iconsax.message_question;
      default:
        return Iconsax.document;
    }
  }

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: _badgeBgColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              alignment: Alignment.center,
              child: Icon(_icon, size: 24.sp, color: _badgeColor),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: _badgeBgColor,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          item.badgeLabel.isNotEmpty
                              ? item.badgeLabel
                              : item.itemType,
                          style: getTextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: _badgeColor,
                          ),
                        ),
                      ),
                      if (item.category != null) ...[
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            item.category!.name,
                            style: getTextStyle(
                              fontSize: 12,
                              color: c.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    item.title,
                    style: getTextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: c.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.description.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      item.description,
                      style: getTextStyle(
                        fontSize: 13,
                        color: c.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
