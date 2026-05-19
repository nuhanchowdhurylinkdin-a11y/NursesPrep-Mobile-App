import 'dart:convert';
// import 'dart:developer';

import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class NotificationRouter {
  NotificationRouter._();

  /// Route based on the `type` field in the notification's data payload.
  /// `data` may come either as a Map (FCM tap) or as a JSON string
  /// (local-notification tap payload).
  static void route(dynamic data) {
    Map<String, dynamic> map;
    if (data is Map) {
      map = Map<String, dynamic>.from(data);
    } else if (data is String && data.isNotEmpty) {
      try {
        map = Map<String, dynamic>.from(jsonDecode(data) as Map);
      } catch (_) {
        map = {'type': data};
      }
    } else {
      return;
    }

    final type = map['type']?.toString();
    // log('NotificationRouter: type=$type, data=$map');

    switch (type) {
      case 'payment_success':
        Get.toNamed(AppRoute.getSubscriptionScreen());
        break;
      case 'payment_failed':
        Get.toNamed(AppRoute.getSubscriptionScreen());
        break;
      case 'refund_processed':
        Get.toNamed(AppRoute.getBillingHistoryScreen());
        break;
      case 'trial_ending':
        Get.toNamed(AppRoute.getChangePlanScreen());
        break;
      case 'promotion':
        Get.toNamed(AppRoute.getChangePlanScreen());
        break;
      case 'feature_update':
      default:
        Get.toNamed(AppRoute.getNotificationsScreen());
        break;
    }
  }
}
