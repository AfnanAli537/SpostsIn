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
  final int status; // 0: Sent, 1: Delivered, 2: Seen
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
  final String userId;
  final String? groupId;
  HubConversationSeenEvent({required this.userId, this.groupId});
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
