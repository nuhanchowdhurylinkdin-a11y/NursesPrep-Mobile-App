// import 'dart:developer';

import '../../utils/constants/api_constants.dart';
import '../network_caller.dart';
import '../storage_service.dart';
import 'fcm_service.dart';

class FcmTokenSync {
  FcmTokenSync._();

  static final _caller = NetworkCaller();

  /// Send the current FCM token to the backend. No-op if user is a guest or
  /// not logged in.
  static Future<void> sync() async {
    if (!StorageService.hasToken() || StorageService.isGuest) return;

    final token = await FcmService.getToken();
    if (token == null || token.isEmpty) return;

    final lastToken = StorageService.lastFcmToken;
    if (lastToken == token) return;

    await _post(token);
    await StorageService.setLastFcmToken(token);
  }

  /// Clear the FCM token on the backend (sends empty string). Call this
  /// before logging the user out.
  static Future<void> clear() async {
    if (!StorageService.hasToken() || StorageService.isGuest) return;
    await _post('');
  }

  static Future<void> _post(String token) async {
    try {
      final response = await _caller.postRequest(
        ApiConstants.fcmToken,
        body: {'fcmToken': token},
      );
      if (!response.isSuccess) {
        // log('FCM token sync failed: ${response.errorMessage}');
      }
    } catch (e) {
      // log('FCM token sync exception: $e');
    }
  }
}
