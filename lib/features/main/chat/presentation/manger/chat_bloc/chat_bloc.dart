import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:sports_in/features/main/chat/data/models/chat_model_import.dart';
import 'package:sports_in/features/main/chat/data/repo/chat_repo.dart';
import 'package:sports_in/features/main/chat/data/service/chat_hub_service.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _repo;
  final ChatHubService _hub;

  ChatBloc({required ChatRepository repo, required ChatHubService hub})
    : _repo = repo,
      _hub = hub,
      super(const ChatState()) {
    // Chat events
    on<LoadChatsEvent>(_onLoadChats);
    on<LoadMoreChatsEvent>(_onLoadMoreChats);
    on<SearchChatsEvent>(_onSearchChats);
    on<MarkChatAsReadEvent>(_onMarkChatAsRead);

    // Message events
    on<LoadMessagesEvent>(_onLoadMessages);
    on<LoadMoreMessagesEvent>(_onLoadMoreMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<EditMessageEvent>(_onEditMessage);
    on<DeleteMessageEvent>(_onDeleteMessage);

    // Contacts/Groups
    on<LoadContactsEvent>(_onLoadContacts);
    on<CreateGroupEvent>(_onCreateGroup);

    // Hub events (incoming)
    on<HubConnectEvent>(_onHubConnect);
    on<HubDisconnectEvent>(_onHubDisconnect);
    on<HubConnectionStateChangedEvent>(_onHubConnectionStateChanged);
    on<HubMessageReceivedEvent>(_onHubMessageReceived);
    on<HubMessageEditedEvent>(_onHubMessageEdited);
    on<HubMessageDeletedEvent>(_onHubMessageDeleted);
    on<HubUserTypingEvent>(_onHubUserTyping);
    on<HubMessageStatusChangedEvent>(_onHubMessageStatusChanged);
    on<HubConversationSeenEvent>(_onHubConversationSeen);
    on<HubUserStatusChangedEvent>(_onHubUserStatusChanged);

    // Hub actions (outgoing)
    on<SendTypingEvent>(_onSendTyping);
    on<NotifySeenEvent>(_onNotifySeen);
  }

  // ─── Chats ─────────────────
  Future<void> _onLoadChats(
    LoadChatsEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(chatsLoading: true, chatsPage: 1));
    final result = await _repo.getAllChats(pageNumber: 1);

    result.fold(
      (e) => emit(state.copyWith(chatsLoading: false, chatsError: e.message)),
      (data) => emit(
        state.copyWith(
          chats: data.items,
          chatsLoading: false,
          chatsHasMore: data.hasNextPage,
          chatsPage: 1,
        ),
      ),
    );
  }

  Future<void> _onMarkChatAsRead(
    MarkChatAsReadEvent event,
    Emitter<ChatState> emit,
  ) async {
    final updatedChats = state.chats
        .map(
          (c) => c.id == event.chatId
              ? ChatModel(
                  id: c.id,
                  title: c.title,
                  groupPhoto: c.groupPhoto,
                  isGroup: c.isGroup,
                  members: c.members,
                  lastMessage: c.lastMessage,
                  lastMessageTime: c.lastMessageTime,
                  unreadCount: 0,
                  isOnline: c.isOnline,
                  lastMessageStatus: c.lastMessageStatus,
                )
              : c,
        )
        .toList();

    emit(state.copyWith(chats: updatedChats));
  }

  // Future<void> _loadCurrentUser() async {
  //   _sharedPref = SharedPref(await SharedPreferences.getInstance());
  //   final user = await _sharedPref.getUserFromPrefs();
  //   if (user?.userId != null) {
  //     _currentUserId = user!.userId!;
  //   }
  // }

  Future<void> _onLoadMoreChats(
    LoadMoreChatsEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (!state.chatsHasMore || state.chatsLoadingMore) return;
    emit(state.copyWith(chatsLoadingMore: true));

    final result = await _repo.getAllChats(pageNumber: state.chatsPage + 1);
    result.fold(
      (e) =>
          emit(state.copyWith(chatsLoadingMore: false, chatsError: e.message)),
      (data) => emit(
        state.copyWith(
          chats: [...state.chats, ...data.items],
          chatsLoadingMore: false,
          chatsHasMore: data.hasNextPage,
          chatsPage: state.chatsPage + 1,
        ),
      ),
    );
  }

  Future<void> _onSearchChats(
    SearchChatsEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(searchQuery: event.query));
    if (event.query.isEmpty) {
      add(LoadChatsEvent());
      return;
    }

    final result = await _repo.chatSearch(searchTerm: event.query);
    result.fold(
      (_) {},
      (data) => emit(state.copyWith(searchResult: data.items)),
    );
  }

  // ─── Messages ─────────────────
  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(messagesLoading: true, messages: []));
    final result = await _repo.getAllMessages(
      targetUserId: event.targetUserId,
      groupId: event.groupId,
      page: 1,
    );

    result.fold(
      (e) => emit(
        state.copyWith(messagesLoading: false, messagesError: e.message),
      ),
      (data) {
        // Ensure messages are sorted by time (oldest → newest)
        final sorted = [...data.items]
          ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
        emit(
          state.copyWith(
            messages: sorted,
            messagesLoading: false,
            messagesHasMore: data.hasNextPage,
            messagesPage: 1,
          ),
        );
      },
    );
  }

  Future<void> _onLoadMoreMessages(
    LoadMoreMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (!state.messagesHasMore || state.messagesLoadingMore) return;
    emit(state.copyWith(messagesLoadingMore: true));

    final result = await _repo.getAllMessages(
      page: state.messagesPage + 1,
      targetUserId: event.targetUserId,
      groupId: event.groupId,
    );

    result.fold(
      (e) => emit(
        state.copyWith(messagesLoadingMore: false, messagesError: e.message),
      ),
      (data) {
        // Merge and keep chronological order
        final combined = [...state.messages, ...data.items]
          ..sort((a, b) => a.sentAt.compareTo(b.sentAt));

        emit(
          state.copyWith(
            messages: combined,
            messagesLoadingMore: false,
            messagesHasMore: data.hasNextPage,
            messagesPage: state.messagesPage + 1,
          ),
        );
      },
    );
  }

  // ─── Send / Edit / Delete ─────────────────
  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final tempMsg = MessageModel(
      id: tempId,
      senderId: event.senderId!,
      senderName: event.senderName!,
      content: event.content,
      sentAt: DateTime.now(),
      isMe: true,
    );
    emit(
      state.copyWith(messages: [...state.messages, tempMsg], isSending: true),
    );

    final result = await _repo.sendMessage(
      content: event.content,
      receiverId: event.receiverId,
      groupId: event.groupId,
      attachmentFile: event.attachmentFile,
    );

    result.fold(
      (e) => emit(
        state.copyWith(
          messages: state.messages.where((m) => m.id != tempId).toList(),
          isSending: false,
          sendError: e.message,
        ),
      ),
      (sent) {
        final updatedMessages = state.messages
            .map((m) => m.id == tempId ? sent : m)
            .toList();

        final chatId = event.groupId ?? event.receiverId;
        final updatedChats = chatId == null
            ? state.chats
            : state.chats
                  .map(
                    (c) => c.id == chatId
                        ? ChatModel(
                            id: c.id,
                            title: c.title,
                            groupPhoto: c.groupPhoto,
                            isGroup: c.isGroup,
                            members: c.members,
                            lastMessage: sent.content,
                            lastMessageTime: sent.sentAt,
                            unreadCount: c.unreadCount,
                            isOnline: c.isOnline,
                            lastMessageStatus: sent.status,
                          )
                        : c,
                  )
                  .toList();

        emit(
          state.copyWith(
            messages: updatedMessages,
            isSending: false,
            chats: updatedChats,
          ),
        );
      },
    );
  }

  Future<void> _onEditMessage(
    EditMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(
      state.copyWith(
        messages: state.messages
            .map(
              (m) => m.id == event.messageId
                  ? m.copyWith(content: event.newContent, isEdited: true)
                  : m,
            )
            .toList(),
      ),
    );

    final result = await _repo.editMessage(
      messageId: event.messageId,
      newContent: event.newContent,
    );
    result.fold((e) => emit(state.copyWith(sendError: e.message)), (_) {
      state.copyWith(sendError: null);
    });
  }

  Future<void> _onDeleteMessage(
    DeleteMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    final before = state.messages;
    emit(
      state.copyWith(
        messages: before.where((m) => m.id != event.messageId).toList(),
      ),
    );

    final result = await _repo.deleteMessage(messageId: event.messageId);
    result.fold(
      (e) => emit(state.copyWith(messages: before, sendError: e.message)),
      (_) {
        state.copyWith(sendError: null);
      },
    );
  }

  // ─── Contacts / Group ─────────────────
  Future<void> _onLoadContacts(
    LoadContactsEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(contactsLoading: true));
    final result = await _repo.getContacts();

    result.fold(
      (_) => emit(state.copyWith(contactsLoading: false)),
      (data) => emit(state.copyWith(contacts: data, contactsLoading: false)),
    );
  }

  Future<void> _onCreateGroup(
    CreateGroupEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isCreatingGroup: true));
    final result = await _repo.createGroup(
      title: event.title,
      memberIds: event.memberIds,
      description: event.description,
      groupPhoto: event.groupPhoto,
    );

    result.fold(
      (e) => emit(
        state.copyWith(isCreatingGroup: false, createGroupError: e.message),
      ),
      (chat) => emit(
        state.copyWith(isCreatingGroup: false, chats: [chat, ...state.chats]),
      ),
    );
  }

  // ─── Hub (SignalR) Integration ─────────────────
  Future<void> _onHubConnect(
    HubConnectEvent event,
    Emitter<ChatState> emit,
  ) async {
    // Register hub callbacks first so we get connection state and messages
    _hub.onConnectionStateChanged = (connectionState) =>
        add(HubConnectionStateChangedEvent(connectionState: connectionState));
    _hub.onReceiveMessage = (message) =>
        add(HubMessageReceivedEvent(message: message));
    _hub.onMessageEdited = (id, content) =>
        add(HubMessageEditedEvent(messageId: id, newContent: content));
    _hub.onMessageDeleted = (id) => add(HubMessageDeletedEvent(messageId: id));
    _hub.onUserTyping = (userId, isTyping) =>
        add(HubUserTypingEvent(userId: userId, isTyping: isTyping));
    _hub.onMessageStatusChanged = (id, status) =>
        add(HubMessageStatusChangedEvent(messageId: id, status: status));
    _hub.onConversationSeen = (senderId, groupId) =>
        add(HubConversationSeenEvent(senderId: senderId, groupId: groupId));
    _hub.onUserStatusChanged = (userId, isOnline, timestamp) => add(
      HubUserStatusChangedEvent(
        userId: userId,
        isOnline: isOnline,
        timestamp: timestamp,
      ),
    );

    try {
      await _hub.connect();
      emit(
        state.copyWith(
          hubConnected: true,
          hubReconnecting: false,
          hubError: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          hubConnected: false,
          hubReconnecting: false,
          hubError: e.toString(),
        ),
      );
    }
  }

  void _onHubConnectionStateChanged(
    HubConnectionStateChangedEvent event,
    Emitter<ChatState> emit,
  ) {
    switch (event.connectionState) {
      case 'connected':
        emit(
          state.copyWith(
            hubConnected: true,
            hubReconnecting: false,
            hubError: '',
          ),
        );
        break;
      case 'reconnecting':
        emit(state.copyWith(hubReconnecting: true));
        break;
      case 'disconnected':
        emit(state.copyWith(hubConnected: false, hubReconnecting: false));
        break;
    }
  }

  Future<void> _onHubDisconnect(
    HubDisconnectEvent event,
    Emitter<ChatState> emit,
  ) async {
    await _hub.disconnect();
    emit(
      state.copyWith(hubConnected: false, hubReconnecting: false, hubError: ''),
    );
  }

  void _onHubMessageReceived(
    HubMessageReceivedEvent event,
    Emitter<ChatState> emit,
  ) {
    // Append and keep messages sorted by time
    // if the message is already in the list, update the existing entry instead of appending a duplicate.
    // fix the issue of the message being duplicated when the user sends a message and then the hub receives the message and sends it back to the user.
    if (state.messages.last.senderId == event.message.senderId) {
      return;
    } else {
      final updatedMessages = [...state.messages, event.message];
      updatedMessages.sort((a, b) => a.sentAt.compareTo(b.sentAt));
      // Clear typing when the sender posts (so we don't show "typing..." after their message)
      state.typingInfo?.userId == event.message.senderId
          ? TypingInfo(userId: event.message.senderId, isTyping: false)
          : state.typingInfo;
      emit(state.copyWith(messages: updatedMessages));
    }

    // Refresh chats so unread counters & last message stay in sync
    add(LoadChatsEvent(isRefresh: true));
  }

  void _onHubMessageEdited(
    HubMessageEditedEvent event,
    Emitter<ChatState> emit,
  ) {
    emit(
      state.copyWith(
        messages: state.messages
            .map(
              (m) => m.id == event.messageId
                  ? m.copyWith(content: event.newContent, isEdited: true)
                  : m,
            )
            .toList(),
      ),
    );
  }

  void _onHubMessageDeleted(
    HubMessageDeletedEvent event,
    Emitter<ChatState> emit,
  ) {
    emit(
      state.copyWith(
        messages: state.messages.where((m) => m.id != event.messageId).toList(),
      ),
    );
  }

  /// Hub sends one-message status (1=sent, 2=delivered, 3=seen); UI uses [chat_view_widgets._buildStatusIcon].
  /// Logic: the message with [event].messageId is updated to [event].status, others unchanged; new list is emitted.
  void _onHubMessageStatusChanged(
    HubMessageStatusChangedEvent event,
    Emitter<ChatState> emit,
  ) {
    final updatedMessages = state.messages.map((m) {
      if (m.id == event.messageId) {
        return m.copyWith(status: event.status);
      }
      return m;
    }).toList();
    emit(state.copyWith(messages: updatedMessages));
  }

  /// Hub says "other side opened conversation"; we mark all my messages in the current view as seen (status 3);
  /// UI shows blue checks via [chat_view_widgets._buildStatusIcon]. We refresh chats and do not send NotifySeen back.
  void _onHubConversationSeen(
    HubConversationSeenEvent event,
    Emitter<ChatState> emit,
  ) {
    final updatedMessages = state.messages
        .map((m) => m.isMe ? m.copyWith(status: 3) : m)
        .toList();
    emit(state.copyWith(messages: updatedMessages));
    add(LoadChatsEvent(isRefresh: true));
  }

  void _onHubUserStatusChanged(
    HubUserStatusChangedEvent event,
    Emitter<ChatState> emit,
  ) {
    final updatedChats = state.chats
        .map(
          (c) => !c.isGroup && c.id == event.userId
              ? ChatModel(
                  id: c.id,
                  title: c.title,
                  groupPhoto: c.groupPhoto,
                  isGroup: c.isGroup,
                  members: c.members,
                  lastMessage: c.lastMessage,
                  lastMessageTime: c.lastMessageTime,
                  unreadCount: c.unreadCount,
                  isOnline: event.isOnline,
                  lastMessageStatus: c.lastMessageStatus,
                )
              : c,
        )
        .toList();

    emit(state.copyWith(chats: updatedChats));
  }

  void _onHubUserTyping(HubUserTypingEvent event, Emitter<ChatState> emit) {
    emit(
      state.copyWith(
        typingInfo: TypingInfo(userId: event.userId, isTyping: event.isTyping),
      ),
    );
  }

  Future<void> _onSendTyping(
    SendTypingEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await _hub.sendTypingNotification(
        targetId: event.targetId,
        isTyping: event.isTyping,
      );
    } catch (_) {
      // Ignore hub errors for typing; no state change needed
    }
  }

  Future<void> _onNotifySeen(
    NotifySeenEvent event,
    Emitter<ChatState> emit,
  ) async {
    log('👁️ notifySeen to: ${event.senderId} (groupId: ${event.groupId})');
    await _hub.notifySeen(
      senderId: event.senderId,
      groupId: event.groupId ?? '',
    );
  }

  @override
  Future<void> close() async {
    await _hub.disconnect();
    return super.close();
  }
}
