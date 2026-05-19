import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/theme/app_colors_extension.dart';
import '../../controller/notifications_controller.dart';
import '../../model/notification_model.dart';
import '../widgets/notification_filter_tabs.dart';
import '../widgets/notification_tile.dart';

class NotificationsScreen extends GetView<NotificationsController> {
  const NotificationsScreen({super.key});

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
          backgroundColor: c.cardBg,
          elevation: 0,
          title: Obx(() {
            final unread = controller.unreadCount.value;
            return Row(
              children: [
                Text(
                  'Alerts',
                  style: getTextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: c.textPrimary,
                  ),
                ),
                if (unread > 0) ...[
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F58BD),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      '$unread',
                      style: getTextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            );
          }),
          centerTitle: false,
          actions: [
            PopupMenuButton<String>(
              icon: Icon(Iconsax.more, color: c.textPrimary),
              onSelected: (value) {
                if (value == 'read_all') {
                  controller.markAllAsRead();
                } else if (value == 'delete_all') {
                  _confirmDeleteAll(context);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                    value: 'read_all', child: Text('Mark all as read')),
                PopupMenuItem(
                    value: 'delete_all', child: Text('Delete all')),
              ],
            ),
            SizedBox(width: 8.w),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: controller.fetchAll,
          child: Obx(() {
            if (controller.isLoading.value && controller.notifications.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final items = controller.filtered;
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    NotificationFilterTabs(
                      selectedIndex: controller.selectedTab.value,
                      onChanged: controller.switchTab,
                    ),
                    SizedBox(height: 20.h),
                    if (items.isEmpty)
                      _buildEmpty(c)
                    else
                      ..._buildGrouped(items, c),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildEmpty(AppColorsExtension c) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 80.h),
      child: Center(
        child: Column(
          children: [
            Icon(Iconsax.notification, size: 48.sp, color: c.textHint),
            SizedBox(height: 12.h),
            Text(
              'No notifications',
              style: getTextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: c.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildGrouped(
      List<NotificationModel> items, AppColorsExtension c) {
    final today = <NotificationModel>[];
    final yesterday = <NotificationModel>[];
    final earlier = <NotificationModel>[];

    final now = DateTime.now();
    final startToday = DateTime(now.year, now.month, now.day);
    final startYesterday = startToday.subtract(const Duration(days: 1));

    for (final n in items) {
      final d = n.createdAt;
      if (d == null) {
        earlier.add(n);
      } else if (!d.isBefore(startToday)) {
        today.add(n);
      } else if (!d.isBefore(startYesterday)) {
        yesterday.add(n);
      } else {
        earlier.add(n);
      }
    }

    final widgets = <Widget>[];
    if (today.isNotEmpty) widgets.addAll(_section('TODAY', today, c));
    if (yesterday.isNotEmpty) {
      widgets.addAll(_section('YESTERDAY', yesterday, c));
    }
    if (earlier.isNotEmpty) widgets.addAll(_section('EARLIER', earlier, c));
    return widgets;
  }

  List<Widget> _section(
      String label, List<NotificationModel> items, AppColorsExtension c) {
    return [
      Text(
        label,
        style: getTextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: c.textHint,
        ),
      ),
      SizedBox(height: 12.h),
      ...items.map(
        (item) => Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: NotificationTile(item: item, controller: controller),
        ),
      ),
      SizedBox(height: 8.h),
    ];
  }

  void _confirmDeleteAll(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete all notifications?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteAll();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
