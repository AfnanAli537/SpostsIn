import 'dart:developer';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/itransport.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/features/notitification/data/model/notifi_model.dart';

@lazySingleton
class NotificationHubService {
  static const String _hubUrl =
      'https://sportsin.runasp.net/notificationHub';

  HubConnection? _hubConnection;
  late SharedPref _sharedPref;

  // ─── Callbacks ──────────────────────────────────────────────────────────────
  /// Connection lifecycle: 'connected' | 'disconnected' | 'reconnecting'
  void Function(String connectionState)? onConnectionStateChanged;

  /// Fired when a new notification arrives from the server
  void Function(NotificationModel notification)? onReceiveNotification;

  // ─── Connection ───────────────────────────────────────────────────────────
  Future<void> connect() async {
    if (_hubConnection != null &&
        _hubConnection!.state == HubConnectionState.Connected) {
      log('🔌 NotificationHub already connected');
      return;
    }

    final sharedPreferences = await SharedPreferences.getInstance();
    _sharedPref = SharedPref(sharedPreferences);
    final accessToken = _sharedPref.getToken() ?? '';

    _hubConnection = HubConnectionBuilder()
        .withUrl(
          _hubUrl,
          options: HttpConnectionOptions(
            accessTokenFactory: () async => accessToken,
            transport: HttpTransportType.WebSockets,
            skipNegotiation: true,
          ),
        )
        .withAutomaticReconnect()
        .build();

    _registerListeners();

    _hubConnection!.onclose(({error}) {
      log('❌ NotificationHub disconnected: $error');
      onConnectionStateChanged?.call('disconnected');
    });

    _hubConnection!.onreconnecting(({error}) {
      log('🔄 NotificationHub reconnecting: $error');
      onConnectionStateChanged?.call('reconnecting');
    });

    _hubConnection!.onreconnected(({connectionId}) {
      log('✅ NotificationHub reconnected: $connectionId');
      onConnectionStateChanged?.call('connected');
    });

    try {
      await _hubConnection!.start();
      log('✅ NotificationHub connected');
      onConnectionStateChanged?.call('connected');
    } catch (e) {
      log('❌ NotificationHub connection failed: $e');
      onConnectionStateChanged?.call('disconnected');
      rethrow;
    }
  }

  Future<void> disconnect() async {
    await _hubConnection?.stop();
    _hubConnection = null;
    onConnectionStateChanged?.call('disconnected');
    log('🔌 NotificationHub disconnected manually');
  }

  bool get isConnected =>
      _hubConnection?.state == HubConnectionState.Connected;

  // ─── Event Listeners ───────────────────────────────────────────────────────
  void _registerListeners() {
    // Fired by: _hubContext.Clients.User(userId).SendAsync("ReceiveNotification", dto)
    _hubConnection!.on('ReceiveNotification', (args) {
      if (args == null || args.isEmpty) return;
      try {
        final data = args[0] as Map<String, dynamic>;
        final notification = NotificationModel.fromJson(data);
        log('🔔 ReceiveNotification: ${notification.title}');
        onReceiveNotification?.call(notification);
      } catch (e) {
        log('❌ Error parsing ReceiveNotification: $e');
      }
    });
  }
}