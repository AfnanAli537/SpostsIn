import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/network/api_client.dart';

final FlutterLocalNotificationsPlugin backgroundNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
bool _isBackgroundInitialized = false;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('🔔 [BACKGROUND] Handling notification: ${message.messageId}');

  if (message.notification != null) {
    log(
      '🔔 [BACKGROUND] OS is handling this automatically. Skipping local display.',
    );
    return;
  }

  try {
    ApiClient? apiClient;
    try {
      apiClient = getIt<ApiClient>();
    } catch (e) {
      log('⚠️ [BACKGROUND] ApiClient not available in background');
    }

    await _showBackgroundNotification(message, apiClient);
  } catch (e) {
    log('❌ [BACKGROUND] Error in background handler: $e');
  }
}

// ✅ Show notification in background
Future<void> _showBackgroundNotification(
  RemoteMessage message,
  ApiClient? apiClient,
) async {
  if (message.notification == null) {
    log('⚠️ [BACKGROUND] Message has no notification');
    return;
  }

  try {
    if (!_isBackgroundInitialized) {
      const AndroidInitializationSettings androidInit =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings iosInit =
          DarwinInitializationSettings();

      await backgroundNotificationsPlugin.initialize(
        settings: const InitializationSettings(
          android: androidInit,
          iOS: iosInit,
        ),
      );

      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.max,
        enableVibration: true,
        enableLights: true,
      );

      await backgroundNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);

      _isBackgroundInitialized = true;
    }

    String? imageUrl = message.notification?.android?.imageUrl;
    AndroidNotificationDetails androidDetails;

    if (imageUrl != null && imageUrl.isNotEmpty && apiClient != null) {
      log('📸 [BACKGROUND] Fetching image: $imageUrl');
      try {
        final response = await apiClient
            .get(imageUrl)
            .timeout(const Duration(seconds: 5));

        if (response.statusCode == 200) {
          final base64Image = base64Encode(response.data);

          final BigPictureStyleInformation bigPictureStyle =
              BigPictureStyleInformation(
                ByteArrayAndroidBitmap.fromBase64String(base64Image),
                largeIcon: ByteArrayAndroidBitmap.fromBase64String(base64Image),
                contentTitle: message.notification?.title,
                summaryText: message.notification?.body,
              );

          androidDetails = AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
            enableVibration: true,
            enableLights: true,
            showWhen: true,
            styleInformation: bigPictureStyle,
          );

          log('✅ [BACKGROUND] Image notification ready');
        } else {
          androidDetails = _getBasicAndroidDetails();
        }
      } catch (e) {
        log('⚠️ [BACKGROUND] Failed to fetch image: $e');
        androidDetails = _getBasicAndroidDetails();
      }
    } else {
      androidDetails = _getBasicAndroidDetails();
    }

    await backgroundNotificationsPlugin.show(
      id: message.notification.hashCode,
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data.isEmpty
          ? null
          : Uri(queryParameters: message.data).toString(),
    );

    log('✅ [BACKGROUND] Notification displayed');
  } catch (e) {
    log('❌ [BACKGROUND] Error showing notification: $e');
  }
}

// ✅ Helper: Basic Android Details
AndroidNotificationDetails _getBasicAndroidDetails() {
  return AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    channelDescription: 'This channel is used for important notifications.',
    importance: Importance.max,
    priority: Priority.high,
    enableVibration: true,
    enableLights: true,
    showWhen: true,
  );
}

// ✅ STATIC/TOP-LEVEL TAP HANDLERS
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  log(
    '🔔 [TAP] Background notification tapped: ${notificationResponse.payload}',
  );
  NotificationStreamController.addNotification(notificationResponse);
}

void notificationTapForeground(NotificationResponse notificationResponse) {
  log(
    '🔔 [TAP] Foreground notification tapped: ${notificationResponse.payload}',
  );
  NotificationStreamController.addNotification(notificationResponse);
}

// ✅ StreamController for notification tap events
class NotificationStreamController {
  static final StreamController<NotificationResponse> _controller =
      StreamController<NotificationResponse>.broadcast();

  static Stream<NotificationResponse> get stream => _controller.stream;

  static void addNotification(NotificationResponse response) {
    if (!_controller.isClosed) {
      _controller.add(response);
      log('✅ Notification added to stream');
    }
  }

  static void dispose() {
    _controller.close();
  }
}

// ✅ Enhanced NotificationService with robust error handling
@lazySingleton
class NotificationService {
  final ApiClient apiClient;

  NotificationService(this.apiClient);

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  bool _isInteractionsSetup = false;

  // ✅ INITIALIZE LOCAL NOTIFICATIONS & FOREGROUND LISTENERS
  Future<void> setupInteractions() async {
    if (_isInteractionsSetup) {
      log(
        '⚠️ [SETUP] Interactions already initialized, skipping duplicate setup.',
      );
      return;
    }
    _isInteractionsSetup = true;
    log('🚀 [SETUP] Initializing NotificationService');

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _localNotifications.initialize(
      settings: InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: notificationTapForeground,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    log('✅ [SETUP] Local notifications initialized');

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel_v2',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      enableVibration: true,
      enableLights: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    log('✅ [SETUP] Notification channel created');

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    log('✅ [SETUP] Background message handler registered');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('🔔 [FOREGROUND] Got a message in foreground!');
      log('📦 [FOREGROUND] Message data: ${message.data}');
      _showNotificationWithImage(message);
    });

    log('✅ [SETUP] Foreground message listener registered');

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('📱 [OPENED APP] Notification opened app: ${message.data}');
      _handleNotificationTap(message.data);
    });

    log('✅ [SETUP] Message opened app listener registered');

    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      log('🚀 [COLD START] App opened from killed state via notification');
      _handleNotificationTap(initialMessage.data);
    }

    log('✅ [SETUP] Cold start check done');

    _fcm.subscribeToTopic('all').then((val) {
      log('✅ Subscribed to "all" topic for broadcasts');
    });
    _fcm.subscribeToTopic('sports_in_updates').then((val) {
      log('✅ Subscribed to "sports_in_updates" topic');
    });

    log('✅ [SETUP] Notification Service: setupInteractions() completed');
  }

  // ✅ REQUEST PERMISSIONS & GET TOKEN WITH RETRY
  Future<void> getTokenAndRegister() async {
    log('📱 [TOKEN] Requesting notification permissions');

    try {
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
        providesAppNotificationSettings: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // ✅ Get token with retry logic
        String? token = await _getTokenWithRetry(maxRetries: 3);

        if (token != null && token.isNotEmpty) {
          log('🔐 [TOKEN] FCM Token obtained: $token');
          await _sendTokenToBackend(token);
        } else {
          log('⚠️ [TOKEN] Could not obtain token after retries');
        }
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        log('⚠️ [TOKEN] Notification permission: provisional');
      } else {
        log('❌ [TOKEN] Notification permission denied');
      }
    } catch (e) {
      log('❌ [TOKEN] Error in getTokenAndRegister: $e');
    }
  }

  // ✅ GET TOKEN WITH RETRY LOGIC
  Future<String?> _getTokenWithRetry({int maxRetries = 3}) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        log('🔐 [TOKEN] Attempt $attempt/$maxRetries');

        final token = await _fcm.getToken().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            log('⚠️ [TOKEN] Token request timed out on attempt $attempt');
            return null;
          },
        );

        if (token != null && token.isNotEmpty) {
          log('✅ [TOKEN] Token obtained on attempt $attempt: $token');
          return token;
        }
      } on FirebaseException catch (e) {
        log('⚠️ [TOKEN] Firebase error on attempt $attempt: ${e.code}');

        if (e.code.contains('unavailable') ||
            e.message?.contains('SERVICE_NOT_AVAILABLE') == true) {
          log('⚠️ [TOKEN] Firebase services not available');

          if (attempt < maxRetries) {
            log('🔄 [TOKEN] Retrying in 2 seconds...');
            await Future.delayed(const Duration(seconds: 2));
          }
        } else {
          log('❌ [TOKEN] Non-recoverable error: ${e.code}');
          return null;
        }
      } catch (e) {
        log('❌ [TOKEN] Error on attempt $attempt: $e');

        if (attempt < maxRetries) {
          log('🔄 [TOKEN] Retrying in 2 seconds...');
          await Future.delayed(const Duration(seconds: 2));
        }
      }
    }

    log('❌ [TOKEN] Failed to get token after $maxRetries attempts');
    return null;
  }

  // ✅ SEND TOKEN TO BACKEND
  Future<void> _sendTokenToBackend(String token) async {
    final endpoint = '/api/Notification/save-device-token';
    try {
      log('📤 [BACKEND] Sending token to: $endpoint');

      final response = await apiClient.post(
        endpoint,
        data: {'token': token, 'platform': 'android'},
      );

      log('✅ [BACKEND] Token sent - Status: ${response.statusCode}');
      log('📤 [BACKEND] Token value: $token');
    } catch (e) {
      log('❌ [BACKEND] Failed to send token: $e');
    }
  }

  // ✅ DELETE TOKEN
  Future<void> deleteToken() async {
    try {
      // 1. Grab the current token before wiping it
      String? token = await _fcm.getToken();

      if (token != null && token.isNotEmpty) {
        // 2. Call the backend to remove it from the database
        final endpoint = '/api/Notification/remove-device-token/$token';
        log('📤 [BACKEND] Calling delete endpoint: $endpoint');

        final response = await apiClient.delete(endpoint);
        log(
          '✅ [BACKEND] Token deleted from server - Status: ${response.statusCode}',
        );
      } else {
        log('⚠️ [TOKEN] No token found to delete from backend');
      }

      // 3. Delete the token locally from the Firebase instance
      await _fcm.deleteToken();
      log('🔐 [TOKEN] FCM Token completely wiped from device');
    } catch (e) {
      log('❌ [TOKEN] Failed to delete token: $e');
    }
  }

  // ✅ SHOW NOTIFICATION WITH IMAGE IN FOREGROUND
  Future<void> _showNotificationWithImage(RemoteMessage message) async {
    if (message.notification == null) {
      log('⚠️ Message has no notification data');
      return;
    }

    try {
      String? imageUrl = message.notification?.android?.imageUrl;
      AndroidNotificationDetails androidDetails;

      if (imageUrl != null && imageUrl.isNotEmpty) {
        log('📸 Fetching image: $imageUrl');
        try {
          final response = await apiClient
              .get(imageUrl)
              .timeout(const Duration(seconds: 5));

          if (response.statusCode == 200) {
            final base64Image = base64Encode(response.data);

            final BigPictureStyleInformation bigPictureStyle =
                BigPictureStyleInformation(
                  ByteArrayAndroidBitmap.fromBase64String(base64Image),
                  largeIcon: ByteArrayAndroidBitmap.fromBase64String(
                    base64Image,
                  ),
                  contentTitle: message.notification?.title,
                  summaryText: message.notification?.body,
                );

            androidDetails = AndroidNotificationDetails(
              'high_importance_channel_v2',
              'High Importance Notifications',
              channelDescription:
                  'This channel is used for important notifications.',
              importance: Importance.max,
              priority: Priority.high,
              enableVibration: true,
              enableLights: true,
              showWhen: true,
              styleInformation: bigPictureStyle,
            );

            log('✅ Image notification ready');
          } else {
            androidDetails = _getBasicAndroidDetails();
          }
        } catch (e) {
          log('⚠️ Failed to fetch image, showing basic notification: $e');
          androidDetails = _getBasicAndroidDetails();
        }
      } else {
        androidDetails = _getBasicAndroidDetails();
      }

      await _localNotifications.show(
        id: message.notification.hashCode,
        title: message.notification?.title,
        body: message.notification?.body,
        notificationDetails: NotificationDetails(
          android: androidDetails,
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.isEmpty
            ? null
            : Uri(queryParameters: message.data).toString(),
      );

      log('✅ Notification displayed');
    } catch (e) {
      log('❌ Error showing notification: $e');
    }
  }

  // ✅ HANDLE NOTIFICATION TAP
  void _handleNotificationTap(dynamic data) {
    Map<String, dynamic> notificationData = {};

    if (data is String) {
      if (data.isEmpty || data == '{}') {
        log('⚠️ Empty notification data');
        return;
      }
      try {
        final uri = Uri(query: data);
        notificationData = uri.queryParameters.map(
          (key, value) => MapEntry(key, value as dynamic),
        );
      } catch (e) {
        log('❌ Failed to parse notification data: $e');
        return;
      }
    } else if (data is Map<String, dynamic>) {
      notificationData = data;
    } else {
      log('⚠️ Unknown data type: ${data.runtimeType}');
      return;
    }

    if (notificationData.isEmpty) {
      log('⚠️ No notification data to handle');
      return;
    }

    log('✨ Notification tapped with data: $notificationData');

    final String? type = notificationData['type'];
    final String? targetId = notificationData['targetId'];

    switch (type) {
      case 'post_like':
        log('👍 Navigate to post: $targetId');
        break;
      case 'comment':
        log('💬 Navigate to comment section: $targetId');
        break;
      case 'follow':
        log('👤 Navigate to profile: $targetId');
        break;
      case 'message':
        log('💬 Navigate to chat: $targetId');
        break;
      default:
        log('❓ Unknown notification type: $type');
    }
  }

  // ✅ GET DEVICE TOKEN
  static Future<String> getDeviceToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      log('📱 Device token retrieved: $token');
      return token ?? '';
    } catch (e) {
      log('❌ Error getting FCM token: $e');
      return '';
    }
  }

  // ✅ LISTEN FOR TOKEN REFRESH
  static void listenTokenRefresh(Function(String) onTokenRefresh) {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      log('🔄 Token refreshed: $newToken');
      onTokenRefresh(newToken);
    });
  }

  // ✅ Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _fcm.subscribeToTopic(topic);
      log('✅ Subscribed to topic: $topic');
    } catch (e) {
      log('❌ Failed to subscribe to topic $topic: $e');
    }
  }

  // ✅ Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _fcm.unsubscribeFromTopic(topic);
      log('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      log('❌ Failed to unsubscribe from topic $topic: $e');
    }
  }

  // ✅ Cleanup
  void dispose() {
    NotificationStreamController.dispose();
  }
}
