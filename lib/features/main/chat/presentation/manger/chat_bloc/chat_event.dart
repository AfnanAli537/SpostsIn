part of 'chat_bloc.dart';

sealed class ChatEvent {}

// ─── Chats ────────────────────────────────────────────────────────────────

class LoadChatsEvent extends ChatEvent {
  final bool isRefresh;
  LoadChatsEvent({this.isRefresh = false});
}

class LoadMoreChatsEvent extends ChatEvent {}

class SearchChatsEvent extends ChatEvent {
  final String query;
  SearchChatsEvent(this.query);
}

/// Fired when the current user opens a conversation and all
/// messages in that chat should be considered read locally.
class MarkChatAsReadEvent extends ChatEvent {
  final String chatId;
  final bool isGroup;
  MarkChatAsReadEvent({required this.chatId, required this.isGroup});
}

// ─── Messages ──────────────────────────────────────────────────────────────

class LoadMessagesEvent extends ChatEvent {
  final String? targetUserId;
  final String? groupId;
  LoadMessagesEvent({this.targetUserId, this.groupId});
}

class LoadMoreMessagesEvent extends ChatEvent {
  final String? targetUserId;
  final String? groupId;
  LoadMoreMessagesEvent({this.targetUserId, this.groupId});
}

class SendMessageEvent extends ChatEvent {
  final String content;
  final String? receiverId;
  final String? groupId;
  final String? attachmentFile;
  final String? senderName;
  final String? senderId;

  SendMessageEvent({
    required this.content,
    this.receiverId,
    this.groupId,
    this.attachmentFile,
    this.senderName,
    this.senderId,
  });
}

class EditMessageEvent extends ChatEvent {
  final String messageId;
  final String newContent;
  EditMessageEvent({required this.messageId, required this.newContent});
}

class DeleteMessageEvent extends ChatEvent {
  final String messageId;
  DeleteMessageEvent(this.messageId);
}

// ─── Hub / Real-time Events ────────────────────────────────────────────────

class HubConnectEvent extends ChatEvent {
  HubConnectEvent();
}

class HubDisconnectEvent extends ChatEvent {}

/// Fired when SignalR connection state changes (from hub service callbacks).
class HubConnectionStateChangedEvent extends ChatEvent {
  /// 'connected' | 'disconnected' | 'reconnecting'
  final String connectionState;
  HubConnectionStateChangedEvent({required this.connectionState});
}

class HubMessageReceivedEvent extends ChatEvent {
  final MessageModel message;
  HubMessageReceivedEvent({required this.message});
}

class HubMessageEditedEvent extends ChatEvent {
  final String messageId;
  final String newContent;
  HubMessageEditedEvent({required this.messageId, required this.newContent});
}

class HubMessageDeletedEvent extends ChatEvent {
  final String messageId;
  HubMessageDeletedEvent({required this.messageId});
}

class HubMessageStatusChangedEvent extends ChatEvent {
  final String messageId;
  // Backend enum: 1 = sent, 2 = delivered, 3 = seen
  final int status;
  HubMessageStatusChangedEvent({required this.messageId, required this.status});
}

class HubUserStatusChangedEvent extends ChatEvent {
  final String userId;
  final bool isOnline;
  final DateTime timestamp;
  HubUserStatusChangedEvent({
    required this.userId,
    required this.isOnline,
    required this.timestamp,
  });
}

class HubConversationSeenEvent extends ChatEvent {
  final String senderId;
  final String? groupId;
  HubConversationSeenEvent({required this.senderId, this.groupId});
}

class HubUserTypingEvent extends ChatEvent {
  final String userId;
  final bool isTyping;
  HubUserTypingEvent({required this.userId, required this.isTyping});
}

// ─── Hub Outgoing Actions ─────────────────────────────────────────────────

class NotifySeenEvent extends ChatEvent {
  final String senderId;
  final String? groupId;
  NotifySeenEvent({required this.senderId, this.groupId});
}

class SendTypingEvent extends ChatEvent {
  final String targetId;
  final bool isTyping;
  SendTypingEvent({required this.targetId, required this.isTyping});
}

// ─── Contacts & Groups ───────────────────────────────────────────────────

class LoadContactsEvent extends ChatEvent {}

class CreateGroupEvent extends ChatEvent {
  final String title;
  final List<String> memberIds;
  final String? description;
  final String? groupPhoto;

  CreateGroupEvent({
    required this.title,
    required this.memberIds,
    this.description,
    this.groupPhoto,
  });
}
