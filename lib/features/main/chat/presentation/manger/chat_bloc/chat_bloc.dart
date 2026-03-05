import 'dart:async';
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
    on<HubMessageReceivedEvent>(_onHubMessageReceived);
    on<HubMessageEditedEvent>(_onHubMessageEdited);
    on<HubMessageDeletedEvent>(_onHubMessageDeleted);
    on<HubUserTypingEvent>(_onHubUserTyping);

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
      (data) => emit(
        state.copyWith(
          messages: data.items,
          messagesLoading: false,
          messagesHasMore: data.hasNextPage,
          messagesPage: 1,
        ),
      ),
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
      (data) => emit(
        state.copyWith(
          messages: [...state.messages, ...data.items],
          messagesLoadingMore: false,
          messagesHasMore: data.hasNextPage,
          messagesPage: state.messagesPage + 1,
        ),
      ),
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
      (sent) => emit(
        state.copyWith(
          messages: state.messages
              .map((m) => m.id == tempId ? sent : m)
              .toList(),
          isSending: false,
        ),
      ),
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
    result.fold((e) => emit(state.copyWith(sendError: e.message)), (_) {});
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
      (_) {},
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
      (data) =>
          emit(state.copyWith(contacts: data.items, contactsLoading: false)),
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

  // ─── Hub Integration ─────────────────
  Future<void> _onHubConnect(
    HubConnectEvent event,
    Emitter<ChatState> emit,
  ) async {
    await _hub.connect();

    // Register hub callbacks to dispatch Bloc events
    _hub.onReceiveMessage = (message) =>
        add(HubMessageReceivedEvent(message: message));
    _hub.onMessageEdited = (id, content) =>
        add(HubMessageEditedEvent(messageId: id, newContent: content));
    _hub.onMessageDeleted = (id) => add(HubMessageDeletedEvent(messageId: id));
    _hub.onUserTyping = (userId, isTyping) =>
        add(HubUserTypingEvent(userId: userId, isTyping: isTyping));

    emit(state.copyWith(hubConnected: true));
  }

  Future<void> _onHubDisconnect(
    HubDisconnectEvent event,
    Emitter<ChatState> emit,
  ) async {
    await _hub.disconnect();
    emit(state.copyWith(hubConnected: false));
  }

  void _onHubMessageReceived(
    HubMessageReceivedEvent event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(messages: [...state.messages, event.message]));
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
    try {
      await _hub.notifySeen(
        senderId: event.senderId,
        groupId: event.groupId ?? '',
      );
    } catch (_) {
      // Ignore hub errors for seen; no state change needed
    }
  }

  @override
  Future<void> close() async {
    await _hub.disconnect();
    return super.close();
  }
}
