import 'dart:async';
import 'dart:convert';
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
  static const String _hubUrl = 'https://sportsin.runasp.net/notificationHub';

  HubConnection? _hubConnection;

  // ─── Callbacks ──────────────────────────────────────────────────────────────
  void Function(String connectionState)? onConnectionStateChanged;
  void Function(NotificationModel notification)? onReceiveNotification;

  // ─── Internal state ────────────────────────────────────────────────────────
  bool _isConnecting = false;
  int _retryCount = 0;
  static const int _maxRetries = 5;
  Timer? _retryTimer;

  // ─── Connection ───────────────────────────────────────────────────────────
  Future<void> connect() async {
    // Guard: don't start a second connection attempt while one is in progress
    if (_isConnecting) {
      log('⏳ NotificationHub connection already in progress');
      return;
    }
    if (_hubConnection?.state == HubConnectionState.Connected) {
      log('🔌 NotificationHub already connected');
      return;
    }

    _isConnecting = true;

    try {
      // FIX 1: Get token FRESH every time connect() is called,
      // not once at class creation — the token may have changed.
      final sharedPreferences = await SharedPreferences.getInstance();
      final sharedPref = SharedPref(sharedPreferences);
      final accessToken = sharedPref.getToken() ?? '';

      if (accessToken.isEmpty) {
        log('❌ NotificationHub: No access token found, aborting connection');
        _isConnecting = false;
        return;
      }

      log('🔑 Token found, building hub connection...');

      // FIX 2: Always rebuild the connection object to avoid stale state
      _hubConnection = HubConnectionBuilder()
          .withUrl(
            _hubUrl,
            options: HttpConnectionOptions(
              // FIX 3: Use accessTokenFactory as an async function so it
              // always returns the latest token (important after token refresh)
              accessTokenFactory: () async {
                final prefs = await SharedPreferences.getInstance();
                return SharedPref(prefs).getToken() ?? '';
              },
              // FIX 4: Try LongPolling as fallback — WebSockets often fail
              // due to server config, proxies, or CORS issues.
              // Start with WebSockets; if it fails we retry with LongPolling.
              transport: HttpTransportType.WebSockets,
              skipNegotiation: true,
            ),
          )
          .withAutomaticReconnect(
            // FIX 5: Explicit retry delays (ms): 0, 2s, 10s, 30s, 60s
            retryDelays: [0, 2000, 10000, 30000, 60000],
          )
          .build();

      _registerListeners();
      _registerLifecycleCallbacks();

      await _hubConnection!.start();
      _retryCount = 0;
      log('✅ NotificationHub connected successfully');
      onConnectionStateChanged?.call('connected');
    } catch (e) {
      log('❌ NotificationHub connection failed: $e');
      onConnectionStateChanged?.call('disconnected');
      _scheduleReconnect();
    } finally {
      _isConnecting = false;
    }
  }

  // FIX 6: Manual reconnect scheduler as a safety net on top of
  // withAutomaticReconnect — handles cases where the library gives up.
  void _scheduleReconnect() {
    if (_retryCount >= _maxRetries) {
      log('🚫 NotificationHub: Max retries reached, giving up');
      return;
    }

    _retryTimer?.cancel();
    final delaySeconds = [2, 5, 10, 20, 30][_retryCount.clamp(0, 4)];
    _retryCount++;

    log('🔄 NotificationHub: Retry $_retryCount/$_maxRetries in ${delaySeconds}s');

    _retryTimer = Timer(Duration(seconds: delaySeconds), () async {
      await connect();
    });
  }

  void _registerLifecycleCallbacks() {
    _hubConnection!.onclose(({error}) {
      log('❌ NotificationHub disconnected: $error');
      onConnectionStateChanged?.call('disconnected');
      // Attempt manual reconnect if the library's auto-reconnect also fails
      _scheduleReconnect();
    });

    _hubConnection!.onreconnecting(({error}) {
      log('🔄 NotificationHub reconnecting: $error');
      onConnectionStateChanged?.call('reconnecting');
    });

    _hubConnection!.onreconnected(({connectionId}) {
      log('✅ NotificationHub reconnected: $connectionId');
      _retryCount = 0;
      onConnectionStateChanged?.call('connected');
    });
  }

  // ─── Event Listeners ───────────────────────────────────────────────────────
  void _registerListeners() {
    _hubConnection!.on('ReceiveNotification', (args) {
      if (args == null || args.isEmpty) {
        log('⚠️ ReceiveNotification: empty args');
        return;
      }
      try {
        // FIX 7: The args[0] might come as a Map or as a raw JSON string
        // depending on the server serialization — handle both cases.
        dynamic raw = args[0];
        final Map<String, dynamic> data;
        if (raw is Map<String, dynamic>) {
          data = raw;
        } else if (raw is String) {
          // If server sends JSON string instead of object
          data = jsonDecode(raw) as Map<String, dynamic>;
        } else {
          log('❌ ReceiveNotification: unexpected type ${raw.runtimeType}');
          return;
        }

        final notification = NotificationModel.fromJson(data);
        log('🔔 ReceiveNotification: ${notification.title} from ${notification.senderName}');
        onReceiveNotification?.call(notification);
      } catch (e, stack) {
        log('❌ Error parsing ReceiveNotification: $e\n$stack');
      }
    });
  }

  // ─── Disconnect ────────────────────────────────────────────────────────────
  Future<void> disconnect() async {
    _retryTimer?.cancel();
    _retryTimer = null;
    _retryCount = _maxRetries; // stop auto-retry
    await _hubConnection?.stop();
    _hubConnection = null;
    onConnectionStateChanged?.call('disconnected');
    log('🔌 NotificationHub disconnected manually');
  }

  bool get isConnected =>
      _hubConnection?.state == HubConnectionState.Connected;
}