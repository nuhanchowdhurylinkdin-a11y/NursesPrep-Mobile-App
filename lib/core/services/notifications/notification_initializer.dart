// import 'dart:developer';

import 'fcm_service.dart';
import 'fcm_token_sync.dart';
import 'local_notification_service.dart';
import 'notification_router.dart';

/// Entry point for the notification system. Call once from `main.dart`
/// after `Firebase.initializeApp`.
class NotificationInitializer {
  NotificationInitializer._();

  static Future<void> init() async {
    await LocalNotificationService.init(
      onTapHandler: NotificationRouter.route,
    );

    await FcmService.init(
      onTokenChangedHandler: (_) => FcmTokenSync.sync(),
      onMessageTapHandler: (_, data) => NotificationRouter.route(data),
    );

    // log('Notification system initialized');
  }
}
