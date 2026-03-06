import 'dart:developer';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/features/main/chat/data/models/chat_model_import.dart';

@lazySingleton
class ChatHubService {
  static const String _hubUrl = 'https://sportsin.runasp.net/ChatHub';

  HubConnection? _hubConnection;
  late SharedPref _sharedPref;

  // ─── Callbacks ──────────────────────────────────────────────────────────────
  void Function(String userId, bool isOnline, DateTime timestamp)?
  onUserStatusChanged;
  void Function(MessageModel message)? onReceiveMessage;
  void Function(String messageId, String newContent)? onMessageEdited;
  void Function(String messageId)? onMessageDeleted;
  void Function(String messageId, int status)? onMessageStatusChanged;
  void Function(String userId, String? groupId)? onConversationSeen;
  void Function(String userId, bool isTyping)? onUserTyping;

  // ─── Connection ───────────────────────────────────────────────────────────
  Future<void> connect() async {
    if (_hubConnection != null &&
        _hubConnection!.state == HubConnectionState.Connected) {
      log('🔌 ChatHub already connected');
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

    _hubConnection!.onclose(({error}) => log('❌ ChatHub disconnected: $error'));
    _hubConnection!.onreconnecting(
      ({error}) => log('🔄 ChatHub reconnecting: $error'),
    );
    _hubConnection!.onreconnected(
      ({connectionId}) => log('✅ ChatHub reconnected: $connectionId'),
    );

    try {
      await _hubConnection!.start();
      log('✅ ChatHub connected');
    } catch (e) {
      log('❌ ChatHub connection failed: $e');
      rethrow;
    }
  }

  Future<void> disconnect() async {
    await _hubConnection?.stop();
    _hubConnection = null;
    log('🔌 ChatHub disconnected manually');
  }

  bool get isConnected => _hubConnection?.state == HubConnectionState.Connected;

  // ─── Event Listeners ───────────────────────────────────────────────────────
  void _registerListeners() {
    _hubConnection!.on('UserStatusChanged', (args) {
      if (args == null || args.length < 3) return;
      final userId = args[0] as String;
      final isOnline = args[1] as bool;
      final timestamp = DateTime.tryParse(args[2].toString()) ?? DateTime.now();
      log('👤 UserStatusChanged: $userId → ${isOnline ? 'online' : 'offline'}');
      onUserStatusChanged?.call(userId, isOnline, timestamp);
    });

    _hubConnection!.on('ReceiveMessage', (args) {
      if (args == null || args.isEmpty) return;
      final data = args[0] as Map<String, dynamic>;
      final message = MessageModel.fromJson(data);
      log('💬 ReceiveMessage: ${message.id}');
      onReceiveMessage?.call(message);
    });

    _hubConnection!.on('MessageEdited', (args) {
      if (args == null || args.length < 2) return;
      final messageId = args[0].toString();
      final newContent = args[1] as String;
      log('✏️ MessageEdited: $messageId');
      onMessageEdited?.call(messageId, newContent);
    });

    _hubConnection!.on('MessageDeleted', (args) {
      if (args == null || args.isEmpty) return;
      final messageId = args[0].toString();
      log('🗑️ MessageDeleted: $messageId');
      onMessageDeleted?.call(messageId);
    });

    _hubConnection!.on('MessageStatusChanged', (args) {
      if (args == null || args.length < 2) return;
      final messageId = args[0].toString();
      final status = args[1] as int;
      log('📬 MessageStatusChanged: $messageId → $status');
      onMessageStatusChanged?.call(messageId, status);
    });

    _hubConnection!.on('ConversationSeen', (args) {
      if (args == null || args.isEmpty) return;
      final userId = args[0] as String;
      final groupId = args.length > 1 ? args[1]?.toString() : null;
      log('👁️ ConversationSeen by: $userId');
      onConversationSeen?.call(userId, groupId);
    });

    _hubConnection!.on('UserTyping', (args) {
      if (args == null || args.length < 2) return;
      final userId = args[0] as String;
      final isTyping = args[1] as bool;
      onUserTyping?.call(userId, isTyping);
    });
  }

  // ─── Outgoing Hub Calls ───────────────────────────────────────────────────

  ///✅ ─── Notify Delivered ─────────────────────────────────────────────────────
  /// API body: MessageId* (string), SenderId* (string)
  /// Hub method: NotifyDelivered(string messageId, string senderId)
  Future<void> notifyDelivered({
    required String messageId,
    required String senderId,
  }) async {
    _ensureConnected();
    await _hubConnection!.invoke(
      'NotifyDelivered',
      args: [messageId, senderId],
    );
    log('📬 notifyDelivered: $messageId');
  }

  ///✅ ─── Notify Seen ───────────────────────────────────────────────────────────
  /// API body: SenderId* (string), GroupId (string)
  /// Hub method: NotifySeen(string senderId, string groupId)
  Future<void> notifySeen({
    required String senderId,
    required String groupId,
  }) async {
    _ensureConnected();
    await _hubConnection!.invoke('NotifySeen', args: [senderId, groupId]);
    log('👁️ notifySeen to: $senderId (groupId: $groupId)');
  }

  ///✅ ─── Send Typing Notification ─────────────────────────────────────────────
  /// API body: TargetId* (string), IsTyping* (bool)
  /// Hub method: SendTypingNotification(string targetId, bool isTyping)
  Future<void> sendTypingNotification({
    required String targetId,
    required bool isTyping,
  }) async {
    _ensureConnected();
    await _hubConnection!.invoke(
      'SendTypingNotification',
      args: [targetId, isTyping],
    );
  }

  ///✅ ─── Join Group ─────────────────────────────────────────────────────────────
  /// API body: GroupId* (string)
  /// Hub method: JoinGroup(string groupId)
  Future<void> joinGroup({required String groupId}) async {
    _ensureConnected();
    await _hubConnection!.invoke('JoinGroup', args: [groupId]);
    log('➕ Joined group: $groupId');
  }

  ///✅ ─── Leave Group ────────────────────────────────────────────────────────────
  /// API body: GroupId* (string)
  /// Hub method: LeaveGroup(string groupId)
  Future<void> leaveGroup({required String groupId}) async {
    _ensureConnected();
    await _hubConnection!.invoke('LeaveGroup', args: [groupId]);
    log('➖ Left group: $groupId');
  }

  ///✅ ─── Private Helpers ─────────────────────────────────────────────────────────
  /// ensure connection is established before invoking hub methods
  void _ensureConnected() {
    if (!isConnected) throw StateError('ChatHubService is not connected.');
  }
}
