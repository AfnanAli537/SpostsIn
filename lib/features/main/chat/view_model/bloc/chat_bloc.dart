import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:sports_in/features/main/chat/data/models/chat_models.dart';
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
    // ── Chats ──────────────────────────────────────────────────────────────
    on<LoadChatsEvent>(_onLoadChats);
    on<LoadMoreChatsEvent>(_onLoadMoreChats);
    on<SearchChatsEvent>(_onSearchChats);

    // ── Messages ───────────────────────────────────────────────────────────
    on<LoadMessagesEvent>(_onLoadMessages);
    on<LoadMoreMessagesEvent>(_onLoadMoreMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<EditMessageEvent>(_onEditMessage);
    on<DeleteMessageEvent>(_onDeleteMessage);

    // ── Contacts ───────────────────────────────────────────────────────────
    on<LoadContactsEvent>(_onLoadContacts);

    // ── Create Group ───────────────────────────────────────────────────────
    on<CreateGroupEvent>(_onCreateGroup);

    // ── Hub Connection ─────────────────────────────────────────────────────
    on<HubConnectEvent>(_onHubConnect);
    on<HubDisconnectEvent>(_onHubDisconnect);

    // ── Hub Incoming Events ────────────────────────────────────────────────
    on<HubMessageReceivedEvent>(_onHubMessageReceived);
    on<HubMessageEditedEvent>(_onHubMessageEdited);
    on<HubMessageDeletedEvent>(_onHubMessageDeleted);
    on<HubMessageStatusChangedEvent>(_onHubMessageStatusChanged);
    on<HubUserStatusChangedEvent>(_onHubUserStatusChanged);
    on<HubConversationSeenEvent>(_onHubConversationSeen);
    on<HubUserTypingEvent>(_onHubUserTyping);

    // ── Hub Outgoing Actions ───────────────────────────────────────────────
    on<NotifySeenEvent>(_onNotifySeen);
    on<SendTypingEvent>(_onSendTyping);
  }

  // ─── Hub Connection ───────────────────────────────────────────────────────

  Future<void> _onHubConnect(HubConnectEvent event, Emitter<ChatState> emit) async {
    try {
      // Wire up all hub callbacks → dispatch back into this Bloc
      _hub.onReceiveMessage = (msg) => add(HubMessageReceivedEvent(msg));
      _hub.onMessageEdited = (id, content) =>
          add(HubMessageEditedEvent(messageId: id, newContent: content));
      _hub.onMessageDeleted = (id) => add(HubMessageDeletedEvent(id));
      _hub.onMessageStatusChanged = (id, status) =>
          add(HubMessageStatusChangedEvent(messageId: id, status: status));
      _hub.onUserStatusChanged = (userId, isOnline, ts) =>
          add(HubUserStatusChangedEvent(userId: userId, isOnline: isOnline, timestamp: ts));
      _hub.onConversationSeen = (userId, groupId) =>
          add(HubConversationSeenEvent(userId: userId, groupId: groupId));
      _hub.onUserTyping = (userId, isTyping) =>
          add(HubUserTypingEvent(userId: userId, isTyping: isTyping));

      await _hub.connect(accessToken: event.accessToken);
      emit(state.copyWith(hubConnected: true));
      log('✅ BLoC: Hub connected');
    } catch (e) {
      log('❌ BLoC: Hub connect failed: $e');
      emit(state.copyWith(hubConnected: false));
    }
  }

  Future<void> _onHubDisconnect(HubDisconnectEvent event, Emitter<ChatState> emit) async {
    await _hub.disconnect();
    emit(state.copyWith(hubConnected: false));
  }

  // ─── Load Chats ───────────────────────────────────────────────────────────

  Future<void> _onLoadChats(LoadChatsEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(
      chatsLoading: true,
      clearChatsError: true,
      chatsPage: 1,
    ));
    try {
      final result = await _repo.getAllChats(pageNumber: 1);
      emit(state.copyWith(
        chats: result.items,
        chatsLoading: false,
        chatsPage: 1,
        chatsHasMore: result.hasNextPage,
      ));
    } catch (e) {
      emit(state.copyWith(chatsLoading: false, chatsError: e.toString()));
    }
  }

  Future<void> _onLoadMoreChats(LoadMoreChatsEvent event, Emitter<ChatState> emit) async {
    if (state.chatsLoadingMore || !state.chatsHasMore) return;
    emit(state.copyWith(chatsLoadingMore: true));
    try {
      final nextPage = state.chatsPage + 1;
      final result = await _repo.getAllChats(pageNumber: nextPage);
      emit(state.copyWith(
        chats: [...state.chats, ...result.items],
        chatsLoadingMore: false,
        chatsPage: nextPage,
        chatsHasMore: result.hasNextPage,
      ));
    } catch (e) {
      emit(state.copyWith(chatsLoadingMore: false, chatsError: e.toString()));
    }
  }

  Future<void> _onSearchChats(SearchChatsEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(searchQuery: event.query));
    // If search query is non-empty, also hit the search API
    if (event.query.trim().isNotEmpty) {
      try {
        final result = await _repo.chatSearch(searchTerm: event.query);
        emit(state.copyWith(chats: result.items));
      } catch (_) {
        // Fail silently — local filter still works via state.filteredChats
      }
    } else {
      // Reset to full list
      add(LoadChatsEvent());
    }
  }

  // ─── Load Messages ────────────────────────────────────────────────────────

  Future<void> _onLoadMessages(LoadMessagesEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(
      messagesLoading: true,
      clearMessagesError: true,
      messagesPage: 1,
      messages: [],
    ));

    try {
      final result = await _repo.getAllMessages(
        targetUserId: event.targetUserId,
        groupId: event.groupId,
        page: 1,
      );
      emit(state.copyWith(
        messages: result.items,
        messagesLoading: false,
        messagesPage: 1,
        messagesHasMore: result.hasNextPage,
      ));

      // Auto notify delivered for received messages
      for (final msg in result.items) {
        if (msg.senderId != 'me' && _hub.isConnected) {
          await _hub.notifyDelivered(messageId: msg.id, senderId: msg.senderId);
        }
      }
    } catch (e) {
      emit(state.copyWith(messagesLoading: false, messagesError: e.toString()));
    }
  }

  Future<void> _onLoadMoreMessages(LoadMoreMessagesEvent event, Emitter<ChatState> emit) async {
    if (state.messagesLoadingMore || !state.messagesHasMore) return;
    emit(state.copyWith(messagesLoadingMore: true));
    try {
      final nextPage = state.messagesPage + 1;
      final result = await _repo.getAllMessages(page: nextPage);
      emit(state.copyWith(
        // Prepend older messages at the top
        messages: [...result.items, ...state.messages],
        messagesLoadingMore: false,
        messagesPage: nextPage,
        messagesHasMore: result.hasNextPage,
      ));
    } catch (e) {
      emit(state.copyWith(messagesLoadingMore: false, messagesError: e.toString()));
    }
  }

  // ─── Send Message ─────────────────────────────────────────────────────────
// Future<void> _onSendMessage(
//   SendMessageEvent event,
//   Emitter<ChatState> emit,
// ) async {
//   final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

//   final tempMsg = MessageModel(
//     id: tempId,
//     senderId: 'me',
//     senderName: 'Me',
//     content: event.content,
//     sentAt: DateTime.now(),
//     isEdited: false,
//     isDeleted: false,
//   );

//   final currentMessages = List<MessageModel>.from(state.messages);

//   emit(state.copyWith(
//     messages: [...currentMessages, tempMsg],
//     isSending: true,
//     clearSendError: true,
//   ));

//   try {
//     await _repo.sendMessage(
//       content: event.content,
//       receiverId: event.receiverId,
//       groupId: event.groupId,
//       attachmentFile: event.attachmentFile,
//     );

//     // Keep the optimistic message (since backend doesn't return the message)
//     emit(state.copyWith(
//       isSending: false,
//     ));
//   } catch (e) {
//     // Remove temp message if sending failed
//     emit(state.copyWith(
//       messages: currentMessages,
//       isSending: false,
//       sendError: e.toString(),
//     ));
//   }
// }
 
  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    // Optimistic UI — add a temp message immediately
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final tempMsg = MessageModel(
      id: tempId,
      senderId: event.senderId!,
      senderName: event.senderName!,
      content: event.content,
      sentAt: DateTime.now(),
      isEdited: false,
      isMe: true,
      isDeleted: false,
    );
    emit(state.copyWith(
      messages: [...state.messages, tempMsg],
      isSending: true,
      clearSendError: true,
    ));

    try {
      final sent = await _repo.sendMessage(
        content: event.content,
        receiverId: event.receiverId,
        groupId: event.groupId,
        attachmentFile: event.attachmentFile,
      );
      // Replace temp message with the real one from the server
      final updated = state.messages
          .map((m) => m.id == tempId ? sent : m)
          .toList();
      emit(state.copyWith(messages: updated, isSending: false));
    } catch (e) {
      // Remove temp message on failure
      emit(state.copyWith(
        messages: state.messages.where((m) => m.id != tempId).toList(),
        isSending: false,
        sendError: e.toString(),
      ));
    }
  }

  // ─── Edit Message ─────────────────────────────────────────────────────────

  Future<void> _onEditMessage(EditMessageEvent event, Emitter<ChatState> emit) async {
    // Optimistic update
    final updated = state.messages.map((m) {
      if (m.id == event.messageId) {
        m.content = event.newContent;
        m.isEdited = true;
      }
      return m;
    }).toList();
    emit(state.copyWith(messages: updated));

    try {
      await _repo.editMessage(messageId: event.messageId, newContent: event.newContent);
    } catch (e) {
      // Revert optimistic update on failure
      emit(state.copyWith(sendError: e.toString()));
    }
  }

  // ─── Delete Message ───────────────────────────────────────────────────────

  Future<void> _onDeleteMessage(DeleteMessageEvent event, Emitter<ChatState> emit) async {
    // Optimistic removal
    final before = List<MessageModel>.from(state.messages);
    emit(state.copyWith(
      messages: state.messages.where((m) => m.id != event.messageId).toList(),
    ));

    try {
      await _repo.deleteMessage(messageId: event.messageId);
    } catch (e) {
      // Revert on failure
      emit(state.copyWith(messages: before, sendError: e.toString()));
    }
  }

  // ─── Load Contacts ────────────────────────────────────────────────────────

  Future<void> _onLoadContacts(LoadContactsEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(contactsLoading: true));
    try {
      final result = await _repo.getContacts();
      emit(state.copyWith(contacts: result.items, contactsLoading: false));
    } catch (e) {
      emit(state.copyWith(contactsLoading: false));
    }
  }

  // ─── Create Group ─────────────────────────────────────────────────────────

  Future<void> _onCreateGroup(CreateGroupEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(
      isCreatingGroup: true,
      groupCreated: false,
      clearCreateGroupError: true,
    ));
    try {
      final newChat = await _repo.createGroup(
        title: event.title,
        memberIds: event.memberIds,
        description: event.description,
        groupPhoto: event.groupPhoto,
      );
      // Join the new group's SignalR room
      if (_hub.isConnected) {
        await _hub.joinGroup(groupId: newChat.id);
      }
      emit(state.copyWith(
        isCreatingGroup: false,
        groupCreated: true,
        chats: [newChat, ...state.chats],
      ));
    } catch (e) {
      emit(state.copyWith(
        isCreatingGroup: false,
        createGroupError: e.toString(),
      ));
    }
  }

  // ─── Hub: Incoming Message ────────────────────────────────────────────────

  Future<void> _onHubMessageReceived(
      HubMessageReceivedEvent event, Emitter<ChatState> emit) async {
    // Add to messages list
    emit(state.copyWith(messages: [...state.messages, event.message]));

    // Notify sender it was delivered
    if (_hub.isConnected) {
      await _hub.notifyDelivered(
        messageId: event.message.id,
        senderId: event.message.senderId,
      );
    }

    // Update last message in chats list
    final updatedChats = state.chats.map((c) {
      final isRelevant = (!c.isGroup && c.members.any((m) => m.userId == event.message.senderId)) ||
          (c.isGroup);
      if (isRelevant) {
        return ChatModel(
          id: c.id,
          title: c.title,
          description: c.description,
          isGroup: c.isGroup,
          groupPhoto: c.groupPhoto,
          members: c.members,
          lastMessage: event.message,
          unreadCount: c.unreadCount + 1,
          updatedAt: event.message.sentAt,
        );
      }
      return c;
    }).toList();
    emit(state.copyWith(chats: updatedChats));
  }

  // ─── Hub: Message Edited ──────────────────────────────────────────────────

  void _onHubMessageEdited(HubMessageEditedEvent event, Emitter<ChatState> emit) {
    final updated = state.messages.map((m) {
      if (m.id == event.messageId) {
        m.content = event.newContent;
        m.isEdited = true;
      }
      return m;
    }).toList();
    emit(state.copyWith(messages: updated));
  }

  // ─── Hub: Message Deleted ─────────────────────────────────────────────────

  void _onHubMessageDeleted(HubMessageDeletedEvent event, Emitter<ChatState> emit) {
    emit(state.copyWith(
      messages: state.messages.where((m) => m.id != event.messageId).toList(),
    ));
  }

  // ─── Hub: Message Status Changed ─────────────────────────────────────────

  void _onHubMessageStatusChanged(
      HubMessageStatusChangedEvent event, Emitter<ChatState> emit) {
    // Status is informational — you can extend MessageModel to include status
    // For now we just log it
    log('📬 Message ${event.messageId} status → ${event.status}');
  }

  // ─── Hub: User Status Changed ─────────────────────────────────────────────

  void _onHubUserStatusChanged(
      HubUserStatusChangedEvent event, Emitter<ChatState> emit) {
    final updated = Map<String, UserOnlineStatus>.from(state.onlineStatuses);
    updated[event.userId] = UserOnlineStatus(
      userId: event.userId,
      isOnline: event.isOnline,
      timestamp: event.timestamp,
    );
    emit(state.copyWith(onlineStatuses: updated));
  }

  // ─── Hub: Conversation Seen ───────────────────────────────────────────────

  void _onHubConversationSeen(
      HubConversationSeenEvent event, Emitter<ChatState> emit) {
    log('👁️ Conversation seen by ${event.userId}');
    // Could update message statuses to "seen" here
  }

  // ─── Hub: User Typing ─────────────────────────────────────────────────────

  void _onHubUserTyping(HubUserTypingEvent event, Emitter<ChatState> emit) {
    emit(state.copyWith(
      typingInfo: TypingInfo(userId: event.userId, isTyping: event.isTyping),
      clearTyping: !event.isTyping,
    ));
  }

  // ─── Notify Seen ──────────────────────────────────────────────────────────

  Future<void> _onNotifySeen(NotifySeenEvent event, Emitter<ChatState> emit) async {
    if (!_hub.isConnected) return;
    await _hub.notifySeen(senderId: event.senderId, groupId: event.groupId);
  }

  // ─── Send Typing ──────────────────────────────────────────────────────────

  Future<void> _onSendTyping(SendTypingEvent event, Emitter<ChatState> emit) async {
    if (!_hub.isConnected) return;
    await _hub.sendTypingNotification(
      targetId: event.targetId,
      isTyping: event.isTyping,
    );
  }

  @override
  Future<void> close() {
    _hub.disconnect();
    return super.close();
  }
}