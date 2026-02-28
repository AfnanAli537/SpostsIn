// part of 'chat_bloc.dart';

// // ─── Message Status Enum ──────────────────────────────────────────────────────

// enum MessageStatus { sent, delivered, seen }

// // ─── Typing Info ──────────────────────────────────────────────────────────────

// class TypingInfo {
//   final String userId;
//   final bool isTyping;
//   const TypingInfo({required this.userId, required this.isTyping});
// }

// // ─── Online Status Map ────────────────────────────────────────────────────────

// class UserOnlineStatus {
//   final String userId;
//   final bool isOnline;
//   final DateTime timestamp;
//   const UserOnlineStatus({
//     required this.userId,
//     required this.isOnline,
//     required this.timestamp,
//   });
// }

// // ─── Base Chat State ──────────────────────────────────────────────────────────

// class ChatState {
//   // ── Chats list ──────────────────────────────────────────────
//   final List<ChatModel> chats;
//   final bool chatsLoading;
//   final bool chatsLoadingMore;
//   final String? chatsError;
//   final int chatsPage;
//   final bool chatsHasMore;
//   final String searchQuery;

//   // ── Messages ─────────────────────────────────────────────────
//   final List<MessageModel> messages;
//   final bool messagesLoading;
//   final bool messagesLoadingMore;
//   final String? messagesError;
//   final int messagesPage;
//   final bool messagesHasMore;

//   // ── Contacts ──────────────────────────────────────────────────
//   final List<ChatMemberModel> contacts;
//   final bool contactsLoading;

//   // ── Send / Edit / Delete ──────────────────────────────────────
//   final bool isSending;
//   final String? sendError;

//   // ── Create Group ──────────────────────────────────────────────
//   final bool isCreatingGroup;
//   final bool groupCreated;
//   final String? createGroupError;

//   // ── Real-time / Hub ───────────────────────────────────────────
//   final bool hubConnected;
//   final Map<String, UserOnlineStatus> onlineStatuses;
//   final TypingInfo? typingInfo;

//   const ChatState({
//     this.chats = const [],
//     this.chatsLoading = false,
//     this.chatsLoadingMore = false,
//     this.chatsError,
//     this.chatsPage = 1,
//     this.chatsHasMore = true,
//     this.searchQuery = '',
//     this.messages = const [],
//     this.messagesLoading = false,
//     this.messagesLoadingMore = false,
//     this.messagesError,
//     this.messagesPage = 1,
//     this.messagesHasMore = true,
//     this.contacts = const [],
//     this.contactsLoading = false,
//     this.isSending = false,
//     this.sendError,
//     this.isCreatingGroup = false,
//     this.groupCreated = false,
//     this.createGroupError,
//     this.hubConnected = false,
//     this.onlineStatuses = const {},
//     this.typingInfo,
//   });

//   ChatState copyWith({
//     List<ChatModel>? chats,
//     bool? chatsLoading,
//     bool? chatsLoadingMore,
//     String? chatsError,
//     int? chatsPage,
//     bool? chatsHasMore,
//     String? searchQuery,
//     List<MessageModel>? messages,
//     bool? messagesLoading,
//     bool? messagesLoadingMore,
//     String? messagesError,
//     int? messagesPage,
//     bool? messagesHasMore,
//     List<ChatMemberModel>? contacts,
//     bool? contactsLoading,
//     bool? isSending,
//     String? sendError,
//     bool? isCreatingGroup,
//     bool? groupCreated,
//     String? createGroupError,
//     bool? hubConnected,
//     Map<String, UserOnlineStatus>? onlineStatuses,
//     TypingInfo? typingInfo,
//     bool clearTyping = false,
//     bool clearSendError = false,
//     bool clearChatsError = false,
//     bool clearMessagesError = false,
//     bool clearCreateGroupError = false,
//   }) {
//     return ChatState(
//       chats: chats ?? this.chats,
//       chatsLoading: chatsLoading ?? this.chatsLoading,
//       chatsLoadingMore: chatsLoadingMore ?? this.chatsLoadingMore,
//       chatsError: clearChatsError ? null : (chatsError ?? this.chatsError),
//       chatsPage: chatsPage ?? this.chatsPage,
//       chatsHasMore: chatsHasMore ?? this.chatsHasMore,
//       searchQuery: searchQuery ?? this.searchQuery,
//       messages: messages ?? this.messages,
//       messagesLoading: messagesLoading ?? this.messagesLoading,
//       messagesLoadingMore: messagesLoadingMore ?? this.messagesLoadingMore,
//       messagesError: clearMessagesError ? null : (messagesError ?? this.messagesError),
//       messagesPage: messagesPage ?? this.messagesPage,
//       messagesHasMore: messagesHasMore ?? this.messagesHasMore,
//       contacts: contacts ?? this.contacts,
//       contactsLoading: contactsLoading ?? this.contactsLoading,
//       isSending: isSending ?? this.isSending,
//       sendError: clearSendError ? null : (sendError ?? this.sendError),
//       isCreatingGroup: isCreatingGroup ?? this.isCreatingGroup,
//       groupCreated: groupCreated ?? this.groupCreated,
//       createGroupError: clearCreateGroupError ? null : (createGroupError ?? this.createGroupError),
//       hubConnected: hubConnected ?? this.hubConnected,
//       onlineStatuses: onlineStatuses ?? this.onlineStatuses,
//       typingInfo: clearTyping ? null : (typingInfo ?? this.typingInfo),
//     );
//   }

//   /// Is a specific user online?
//   bool isUserOnline(String userId) =>
//       onlineStatuses[userId]?.isOnline ?? false;

//   /// Filtered chats by search query
//   List<ChatModel> get filteredChats {
//     if (searchQuery.isEmpty) return chats;
//     return chats
//         .where((c) => c.title!.toLowerCase().contains(searchQuery.toLowerCase()))
//         .toList();
//   }
// }




part of 'chat_bloc.dart';

// ─── Typing Info ──────────────────────────────────────────────────────────────

class TypingInfo {
  final String userId;
  final bool isTyping;
  const TypingInfo({required this.userId, required this.isTyping});
}

// ─── Online Status ────────────────────────────────────────────────────────────

class UserOnlineStatus {
  final String userId;
  final bool isOnline;
  final DateTime timestamp;
  const UserOnlineStatus({
    required this.userId,
    required this.isOnline,
    required this.timestamp,
  });
}

// ─── Chat State ───────────────────────────────────────────────────────────────

class ChatState {
  // ── Chats list ──────────────────────────────────────────────────────────────
  final List<ChatModel> chats;
  final bool chatsLoading;
  final bool chatsLoadingMore;
  final String? chatsError;
  final int chatsPage;
  final bool chatsHasMore;
  final String searchQuery;

  // ── Messages ─────────────────────────────────────────────────────────────────
  final List<MessageModel> messages;
  final bool messagesLoading;
  final bool messagesLoadingMore;
  final String? messagesError;
  final int messagesPage;
  final bool messagesHasMore;

  // ── Contacts ─────────────────────────────────────────────────────────────────
  final List<ChatMemberModel> contacts; // ✅ was List<ContactModel>
  final bool contactsLoading;

  // ── Send / Edit / Delete ──────────────────────────────────────────────────────
  final bool isSending;
  final String? sendError;

  // ── Create Group ──────────────────────────────────────────────────────────────
  final bool isCreatingGroup;
  final bool groupCreated;
  final String? createGroupError;

  // ── Real-time / Hub ───────────────────────────────────────────────────────────
  final bool hubConnected;
  final Map<String, UserOnlineStatus> onlineStatuses;
  final TypingInfo? typingInfo;

  const ChatState({
    this.chats = const [],
    this.chatsLoading = false,
    this.chatsLoadingMore = false,
    this.chatsError,
    this.chatsPage = 1,
    this.chatsHasMore = true,
    this.searchQuery = '',
    this.messages = const [],
    this.messagesLoading = false,
    this.messagesLoadingMore = false,
    this.messagesError,
    this.messagesPage = 1,
    this.messagesHasMore = true,
    this.contacts = const [],
    this.contactsLoading = false,
    this.isSending = false,
    this.sendError,
    this.isCreatingGroup = false,
    this.groupCreated = false,
    this.createGroupError,
    this.hubConnected = false,
    this.onlineStatuses = const {},
    this.typingInfo,
  });

  ChatState copyWith({
    List<ChatModel>? chats,
    bool? chatsLoading,
    bool? chatsLoadingMore,
    String? chatsError,
    int? chatsPage,
    bool? chatsHasMore,
    String? searchQuery,
    List<MessageModel>? messages,
    bool? messagesLoading,
    bool? messagesLoadingMore,
    String? messagesError,
    int? messagesPage,
    bool? messagesHasMore,
    List<ChatMemberModel>? contacts, // ✅ was ContactModel
    bool? contactsLoading,
    bool? isSending,
    String? sendError,
    bool? isCreatingGroup,
    bool? groupCreated,
    String? createGroupError,
    bool? hubConnected,
    Map<String, UserOnlineStatus>? onlineStatuses,
    TypingInfo? typingInfo,
    // clear flags
    bool clearTyping = false,
    bool clearSendError = false,
    bool clearChatsError = false,
    bool clearMessagesError = false,
    bool clearCreateGroupError = false,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      chatsLoading: chatsLoading ?? this.chatsLoading,
      chatsLoadingMore: chatsLoadingMore ?? this.chatsLoadingMore,
      chatsError: clearChatsError ? null : (chatsError ?? this.chatsError),
      chatsPage: chatsPage ?? this.chatsPage,
      chatsHasMore: chatsHasMore ?? this.chatsHasMore,
      searchQuery: searchQuery ?? this.searchQuery,
      messages: messages ?? this.messages,
      messagesLoading: messagesLoading ?? this.messagesLoading,
      messagesLoadingMore: messagesLoadingMore ?? this.messagesLoadingMore,
      messagesError: clearMessagesError ? null : (messagesError ?? this.messagesError),
      messagesPage: messagesPage ?? this.messagesPage,
      messagesHasMore: messagesHasMore ?? this.messagesHasMore,
      contacts: contacts ?? this.contacts,
      contactsLoading: contactsLoading ?? this.contactsLoading,
      isSending: isSending ?? this.isSending,
      sendError: clearSendError ? null : (sendError ?? this.sendError),
      isCreatingGroup: isCreatingGroup ?? this.isCreatingGroup,
      groupCreated: groupCreated ?? this.groupCreated,
      createGroupError: clearCreateGroupError ? null : (createGroupError ?? this.createGroupError),
      hubConnected: hubConnected ?? this.hubConnected,
      onlineStatuses: onlineStatuses ?? this.onlineStatuses,
      typingInfo: clearTyping ? null : (typingInfo ?? this.typingInfo),
    );
  }

  /// Is a specific user online?
  bool isUserOnline(String userId) => onlineStatuses[userId]?.isOnline ?? false;

  /// Filtered chats by search query (client-side)
  List<ChatModel> get filteredChats {
    if (searchQuery.isEmpty) return chats;
    return chats
        .where((c) => c.displayName.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }
}