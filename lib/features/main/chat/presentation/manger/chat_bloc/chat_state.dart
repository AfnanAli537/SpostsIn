part of 'chat_bloc.dart';

class ChatState {
  // ─── Chats ─────────────────
  final List<ChatModel> chats;
  final bool chatsLoading;
  final bool chatsLoadingMore;
  final int chatsPage;
  final bool chatsHasMore;
  final String? chatsError;
  final String? searchQuery;
  final List<SearchResultModel> searchResult;

  // ─── Messages ─────────────────
  final List<MessageModel> messages;
  final bool messagesLoading;
  final bool messagesLoadingMore;
  final int messagesPage;
  final bool messagesHasMore;
  final String? messagesError;
  final bool isSending;
  final String? sendError;

  // ─── Contacts / Group ─────────────────
  final List<ContactModel> contacts;
  final bool contactsLoading;
  final bool isCreatingGroup;
  final String? createGroupError;

  // ─── Hub / Real-time ─────────────────
  final bool hubConnected;
  final TypingInfo? typingInfo;

  const ChatState({
    this.chats = const [],
    this.chatsLoading = false,
    this.chatsLoadingMore = false,
    this.chatsPage = 1,
    this.chatsHasMore = true,
    this.chatsError,
    this.searchQuery,
    this.searchResult = const [],
    this.messages = const [],
    this.messagesLoading = false,
    this.messagesLoadingMore = false,
    this.messagesPage = 1,
    this.messagesHasMore = true,
    this.messagesError,
    this.isSending = false,
    this.sendError,
    this.contacts = const [],
    this.contactsLoading = false,
    this.isCreatingGroup = false,
    this.createGroupError,
    this.hubConnected = false,
    this.typingInfo,
  });

  ChatState copyWith({
    List<ChatModel>? chats,
    bool? chatsLoading,
    bool? chatsLoadingMore,
    int? chatsPage,
    bool? chatsHasMore,
    String? chatsError,
    String? searchQuery,
    List<SearchResultModel>? searchResult,
    List<MessageModel>? messages,
    bool? messagesLoading,
    bool? messagesLoadingMore,
    int? messagesPage,
    bool? messagesHasMore,
    String? messagesError,
    bool? isSending,
    String? sendError,
    List<ContactModel>? contacts,
    bool? contactsLoading,
    bool? isCreatingGroup,
    String? createGroupError,
    bool? hubConnected,
    TypingInfo? typingInfo,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      chatsLoading: chatsLoading ?? this.chatsLoading,
      chatsLoadingMore: chatsLoadingMore ?? this.chatsLoadingMore,
      chatsPage: chatsPage ?? this.chatsPage,
      chatsHasMore: chatsHasMore ?? this.chatsHasMore,
      chatsError: chatsError ?? this.chatsError,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResult: searchResult ?? this.searchResult,
      messages: messages ?? this.messages,
      messagesLoading: messagesLoading ?? this.messagesLoading,
      messagesLoadingMore: messagesLoadingMore ?? this.messagesLoadingMore,
      messagesPage: messagesPage ?? this.messagesPage,
      messagesHasMore: messagesHasMore ?? this.messagesHasMore,
      messagesError: messagesError ?? this.messagesError,
      isSending: isSending ?? this.isSending,
      sendError: sendError ?? this.sendError,
      contacts: contacts ?? this.contacts,
      contactsLoading: contactsLoading ?? this.contactsLoading,
      isCreatingGroup: isCreatingGroup ?? this.isCreatingGroup,
      createGroupError: createGroupError ?? this.createGroupError,
      hubConnected: hubConnected ?? this.hubConnected,
      typingInfo: typingInfo ?? this.typingInfo,
    );
  }
}

class TypingInfo {
  final String userId;
  final bool isTyping;

  TypingInfo({required this.userId, required this.isTyping});
}
