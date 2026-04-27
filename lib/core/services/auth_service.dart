import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'push_notification_service.dart';

class AuthService {
  // Send device token to backend using ApiClient
  static Future<bool> sendDeviceToken({required String userId}) async {
    try {
      final String token = await NotificationService.getDeviceToken();

      if (token.isEmpty) {
        log('❌ Failed to get FCM token');
        return false;
      }

      final ApiClient apiClient = getIt<ApiClient>();
      
      final response = await apiClient.post(
        '/v1/auth/device-token', // Your backend endpoint
        data: {
          'token': token,
          'platform': 'android', // or 'ios'
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('✅ Device token sent successfully to backend');
        return true;
      } else {
        log('❌ Failed to send token: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('❌ Error sending token: $e');
      return false;
    }
  }

  // Setup listener for token refresh and automatically update backend
  static void setupTokenRefreshListener({required String userId}) {
    NotificationService.listenTokenRefresh((newToken) {
      log('🔄 Token refreshed, updating backend...');
      sendDeviceToken(userId: userId);
    });
  }

  // ✅ DELETE TOKEN ON LOGOUT
  static Future<void> deleteDeviceTokenOnLogout() async {
    try {
      final String token = await NotificationService.getDeviceToken();
      if (token.isNotEmpty) {
        final ApiClient apiClient = getIt<ApiClient>();
        // Call your backend to remove this token from the user's record
        await apiClient.delete('/v1/auth/device-token', data: {'token': token});
      }
      // Also delete the token from Firebase locally
      await FirebaseMessaging.instance.deleteToken();
      log('🗑️ Device token deleted successfully');
    } catch (e) {
      log('❌ Error deleting token: $e');
    }
  }
}