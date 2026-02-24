import 'dart:developer';
import 'package:injectable/injectable.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:sports_in/features/main/chat/data/models/chat_models.dart';

@lazySingleton
class ChatHubService {
  static const String _hubUrl = 'https://sportsin.runasp.net/chatHub';

  HubConnection? _hubConnection;

  // ─── Callbacks (set these from your Cubit/ViewModel) ─────────────────────

  /// Fired when a user comes online or goes offline
  /// (userId, isOnline, timestamp)
  void Function(String userId, bool isOnline, DateTime timestamp)?
      onUserStatusChanged;

  /// Fired when a new message arrives
  void Function(MessageModel message)? onReceiveMessage;

  /// Fired when a message is edited
  /// (messageId, newContent)
  void Function(String messageId, String newContent)? onMessageEdited;

  /// Fired when a message is deleted
  void Function(String messageId)? onMessageDeleted;

  /// Fired when delivery/seen status changes
  /// (messageId, status) — 0: Sent, 1: Delivered, 2: Seen
  void Function(String messageId, int status)? onMessageStatusChanged;

  /// Fired when the other party has seen the conversation
  /// (userId, groupId?) — groupId is null for direct chats
  void Function(String userId, String? groupId)? onConversationSeen;

  /// Fired when the other party starts/stops typing
  void Function(String userId, bool isTyping)? onUserTyping;

  // ─── Connection ───────────────────────────────────────────────────────────

  Future<void> connect({required String accessToken}) async {
    if (_hubConnection != null &&
        _hubConnection!.state == HubConnectionState.Connected) {
      log('🔌 ChatHub already connected');
      return;
    }

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
      log('❌ ChatHub disconnected: $error');
    });

    _hubConnection!.onreconnecting(({error}) {
      log('🔄 ChatHub reconnecting: $error');
    });

    _hubConnection!.onreconnected(({connectionId}) {
      log('✅ ChatHub reconnected: $connectionId');
    });

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

  bool get isConnected =>
      _hubConnection?.state == HubConnectionState.Connected;

  // ─── Register Incoming Event Listeners ───────────────────────────────────

  void _registerListeners() {
    // UserStatusChanged(userId, isOnline, timestamp)
    _hubConnection!.on('UserStatusChanged', (args) {
      if (args == null || args.length < 3) return;
      final userId = args[0] as String;
      final isOnline = args[1] as bool;
      final timestamp = DateTime.tryParse(args[2].toString()) ?? DateTime.now();
      log('👤 UserStatusChanged: $userId → ${isOnline ? 'online' : 'offline'}');
      onUserStatusChanged?.call(userId, isOnline, timestamp);
    });

    // ReceiveMessage(messageReadDto)
    _hubConnection!.on('ReceiveMessage', (args) {
      if (args == null || args.isEmpty) return;
      final data = args[0] as Map<String, dynamic>;
      final message = MessageModel.fromJson(data);
      log('💬 ReceiveMessage: ${message.id}');
      onReceiveMessage?.call(message);
    });

    // MessageEdited(messageId, newContent)
    _hubConnection!.on('MessageEdited', (args) {
      if (args == null || args.length < 2) return;
      final messageId = args[0].toString();
      final newContent = args[1] as String;
      log('✏️ MessageEdited: $messageId');
      onMessageEdited?.call(messageId, newContent);
    });

    // MessageDeleted(messageId)
    _hubConnection!.on('MessageDeleted', (args) {
      if (args == null || args.isEmpty) return;
      final messageId = args[0].toString();
      log('🗑️ MessageDeleted: $messageId');
      onMessageDeleted?.call(messageId);
    });

    // MessageStatusChanged(messageId, status)
    _hubConnection!.on('MessageStatusChanged', (args) {
      if (args == null || args.length < 2) return;
      final messageId = args[0].toString();
      final status = args[1] as int;
      log('📬 MessageStatusChanged: $messageId → $status');
      onMessageStatusChanged?.call(messageId, status);
    });

    // ConversationSeen(userId, groupId?)
    _hubConnection!.on('ConversationSeen', (args) {
      if (args == null || args.isEmpty) return;
      final userId = args[0] as String;
      final groupId = args.length > 1 ? args[1]?.toString() : null;
      log('👁️ ConversationSeen by: $userId');
      onConversationSeen?.call(userId, groupId);
    });

    // UserTyping(userId, isTyping)
    _hubConnection!.on('UserTyping', (args) {
      if (args == null || args.length < 2) return;
      final userId = args[0] as String;
      final isTyping = args[1] as bool;
      onUserTyping?.call(userId, isTyping);
    });
  }

  // ─── Outgoing Hub Calls ───────────────────────────────────────────────────

  /// Call when a message is delivered to the device
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

  /// Call when the user opens/reads a conversation
  /// Pass [groupId] for group chats, leave null for direct chats
  Future<void> notifySeen({
    required String senderId,
    String? groupId,
  }) async {
    _ensureConnected();
    await _hubConnection!.invoke(
      'NotifySeen',
      args: [senderId, ?groupId],
    );
    log('👁️ notifySeen to: $senderId');
  }

  /// Call when the user starts or stops typing
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

  /// Join a SignalR group room (needed for group chats)
  Future<void> joinGroup({required String groupId}) async {
    _ensureConnected();
    await _hubConnection!.invoke('JoinGroup', args: [groupId]);
    log('➕ Joined group: $groupId');
  }

  /// Leave a SignalR group room
  Future<void> leaveGroup({required String groupId}) async {
    _ensureConnected();
    await _hubConnection!.invoke('LeaveGroup', args: [groupId]);
    log('➖ Left group: $groupId');
  }

  // ─── Helper ───────────────────────────────────────────────────────────────

  void _ensureConnected() {
    if (!isConnected) {
      throw StateError(
        'ChatHubService is not connected. Call connect() first.',
      );
    }
  }
}