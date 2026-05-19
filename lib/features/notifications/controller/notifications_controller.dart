import 'package:get/get.dart';

import '../../../core/services/network_caller.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';
import '../../../core/utils/helpers/app_helper.dart';
import '../model/notification_model.dart';

class NotificationsController extends GetxController {
  final _networkCaller = NetworkCaller();

  final selectedTab = 0.obs;
  final isLoading = false.obs;
  final isProcessing = false.obs;

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    await Future.wait([fetchNotifications(), fetchUnreadCount()]);
  }

  void switchTab(int index) {
    selectedTab.value = index;
  }

  List<NotificationModel> get filtered {
    if (selectedTab.value == 1) {
      return notifications.where((n) => !n.isRead).toList();
    }
    return notifications.toList();
  }

  Future<void> fetchNotifications() async {
    if (StorageService.isGuest || !StorageService.hasToken()) {
      notifications.clear();
      return;
    }

    try {
      isLoading.value = true;
      final response =
          await _networkCaller.getRequest(ApiConstants.notifications);
      if (response.isSuccess) {
        final raw = response.responseData['data'];
        final list = raw is List
            ? raw
            : (raw is Map && raw['items'] is List ? raw['items'] as List : []);
        notifications.value = list
            .whereType<Map>()
            .map((e) => NotificationModel.fromJson(
                Map<String, dynamic>.from(e)))
            .toList();
      }
    } catch (_) {
      AppHelperFunctions.showErrorSnackBar('Failed to load notifications');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUnreadCount() async {
    if (StorageService.isGuest || !StorageService.hasToken()) {
      unreadCount.value = 0;
      return;
    }

    try {
      final response = await _networkCaller
          .getRequest(ApiConstants.notificationsUnreadCount);
      if (response.isSuccess) {
        final data = response.responseData['data'];
        if (data is Map) {
          unreadCount.value =
              (data['unreadCount'] ?? data['count'] ?? 0) as int;
        } else if (data is int) {
          unreadCount.value = data;
        }
      }
    } catch (_) {}
  }

  Future<void> markAsRead(String id) async {
    final idx = notifications.indexWhere((n) => n.id == id);
    if (idx == -1 || notifications[idx].isRead) return;

    notifications[idx] = notifications[idx]
        .copyWith(isRead: true, readAt: DateTime.now());
    if (unreadCount.value > 0) unreadCount.value -= 1;

    final response = await _networkCaller
        .patchRequest(ApiConstants.notificationRead(id));
    if (!response.isSuccess) {
      await fetchAll();
    }
  }

  Future<void> markAllAsRead() async {
    if (notifications.every((n) => n.isRead)) return;

    try {
      isProcessing.value = true;
      final response = await _networkCaller
          .patchRequest(ApiConstants.notificationsReadAll);
      if (response.isSuccess) {
        notifications.value = notifications
            .map((n) => n.copyWith(isRead: true, readAt: DateTime.now()))
            .toList();
        unreadCount.value = 0;
      } else {
        AppHelperFunctions.showErrorSnackBar(
            response.errorMessage.isNotEmpty
                ? response.errorMessage
                : 'Failed to mark all as read');
      }
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> deleteOne(String id) async {
    final idx = notifications.indexWhere((n) => n.id == id);
    if (idx == -1) return;
    final removed = notifications.removeAt(idx);
    if (!removed.isRead && unreadCount.value > 0) unreadCount.value -= 1;

    final response = await _networkCaller
        .deleteRequest(ApiConstants.notificationDelete(id));
    if (!response.isSuccess) {
      await fetchAll();
      AppHelperFunctions.showErrorSnackBar('Failed to delete notification');
    }
  }

  Future<void> deleteAll() async {
    if (notifications.isEmpty) return;

    try {
      isProcessing.value = true;
      final response = await _networkCaller
          .deleteRequest(ApiConstants.notificationsDeleteAll);
      if (response.isSuccess) {
        notifications.clear();
        unreadCount.value = 0;
      } else {
        AppHelperFunctions.showErrorSnackBar(
            response.errorMessage.isNotEmpty
                ? response.errorMessage
                : 'Failed to delete notifications');
      }
    } finally {
      isProcessing.value = false;
    }
  }
}
