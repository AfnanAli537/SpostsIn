import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/core/utils/helper/date_time_helper.dart';
import 'package:sports_in/features/main/chat/data/models/chat_model_import.dart';
import 'package:sports_in/features/main/chat/presentation/manger/chat_bloc/chat_bloc.dart';
import 'package:sports_in/features/main/chat/presentation/view/widgets/chat_avatar.dart';

part 'widgets/chat_view_widgets.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key, required this.chat, required this.currentUserId});

  final ChatModel chat;
  final String currentUserId;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final _inputController = TextEditingController();
  final _editController = TextEditingController();
  final _scrollController = ScrollController();

  String? _editingId;
  Timer? _typingTimer;
  bool _isTyping = false;
  final String _currentUserName = 'Me';
  late SharedPref _sharedPref;

  String? get _otherUserId => widget.chat.isGroup ? null : widget.chat.id;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _connectHub();

    // As soon as the conversation screen opens, consider existing
    // messages in this chat as seen locally and clear its unread badge.
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySeen());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels <= 100) {
        context.read<ChatBloc>().add(
          LoadMoreMessagesEvent(
            targetUserId: widget.chat.isGroup ? null : widget.chat.id,
            groupId: widget.chat.isGroup ? widget.chat.id : null,
          ),
        );
      }
    });
  }

  void _connectHub() {
    context.read<ChatBloc>().add(HubConnectEvent());
  }

  void _loadMessages() {
    context.read<ChatBloc>().add(
      LoadMessagesEvent(
        targetUserId: widget.chat.isGroup ? null : widget.chat.id,
        groupId: widget.chat.isGroup ? widget.chat.id : null,
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _editController.dispose();
    _scrollController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    final receiverId = widget.chat.isGroup ? null : widget.chat.id;
    final groupId = widget.chat.isGroup ? widget.chat.id : null;

    context.read<ChatBloc>().add(
      SendMessageEvent(
        content: text,
        receiverId: receiverId,
        groupId: groupId,
        senderName: _currentUserName,
        senderId: widget.currentUserId,
      ),
    );

    _inputController.clear();
    _sendTypingIndicator(false);
    _scrollToBottom();
  }

  void _onTextChanged(String value) {
    if (value.isNotEmpty && !_isTyping) {
      _isTyping = true;
      _sendTypingIndicator(true);
    }

    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      _isTyping = false;
      _sendTypingIndicator(false);
    });
  }

  void _sendTypingIndicator(bool isTyping) {
    final targetId = _otherUserId ?? widget.chat.id;
    try {
      context.read<ChatBloc>().add(
        SendTypingEvent(targetId: targetId, isTyping: isTyping),
      );
    } catch (_) {}
  }

  void _notifySeen() {
    final bloc = context.read<ChatBloc>();

    // Update local unread counter for this chat
    bloc.add(
      MarkChatAsReadEvent(chatId: widget.chat.id, isGroup: widget.chat.isGroup),
    );
  }

  void _startEdit(MessageModel msg) {
    setState(() {
      _editingId = msg.id;
      _editController.text = msg.content;
    });
  }

  void _saveEdit() {
    if (_editingId == null || _editController.text.trim().isEmpty) return;

    context.read<ChatBloc>().add(
      EditMessageEvent(
        messageId: _editingId!,
        newContent: _editController.text.trim(),
      ),
    );

    setState(() => _editingId = null);
  }

  void _deleteMessage(String id) {
    context.read<ChatBloc>().add(DeleteMessageEvent(id));
  }

  String _getTypingUserName(ChatState state) {
    final userId = state.typingInfo?.userId ?? '';
    final member = widget.chat.members.firstWhere(
      (m) => m.userId == userId,
      orElse: () =>
          const ChatMemberModel(userId: '', userName: 'Someone', isAdmin: true),
    );
    return member.userName.split(' ').first;
  }

  Widget _buildMessageList(ChatState state) {
    if (state.messagesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.messagesError != null && state.messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 8),
            Text(
              state.messagesError!,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadMessages,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _notifySeen();
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        itemCount: state.messages.length + (state.messagesLoadingMore ? 1 : 0),
        itemBuilder: (_, i) {
          if (state.messagesLoadingMore && i == 0) {
            return const Padding(
              padding: EdgeInsets.all(8),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }

          final msgIndex = state.messagesLoadingMore ? i - 1 : i;
          final msg = state.messages[msgIndex];
          final isEditing = _editingId == msg.id;

          return _MessageBubble(
            message: msg,
            currentUserId: widget.currentUserId,
            isGroupChat: widget.chat.isGroup,
            isEditing: isEditing,
            editController: _editController,
            onLongPress: msg.senderId == widget.currentUserId
                ? () => _showMessageOptions(context, msg)
                : null,
            onSaveEdit: _saveEdit,
            onCancelEdit: () => setState(() => _editingId = null),
            timeText: ChatTimeHelper.messageTime(msg.sentAt),
          );
        },
      ),
    );
  }

  void _showMessageOptions(BuildContext context, MessageModel msg) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF0F5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            /// if seend mesage is not time t 15 minutes then no show edit else show edit and delete options
            if (msg.sentAt.isAfter(
              DateTime.now().subtract(Duration(minutes: 15)),
            ))
              _OptionTile(
                icon: Icons.edit_rounded,
                label: 'Edit',
                color: Colors.black87,
                onTap: () {
                  Navigator.pop(context);
                  _startEdit(msg);
                },
              ),

            const Divider(height: 1, color: Color(0xFFEEF0F5)),

            _OptionTile(
              icon: Icons.delete_outline_rounded,
              label: 'Delete',
              color: Colors.redAccent,
              onTap: () {
                Navigator.pop(context);
                _deleteMessage(msg.id);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: _ChatAppBar(chat: widget.chat),
      body: BlocConsumer<ChatBloc, ChatState>(
        listenWhen: (p, c) =>
            p.messages.length != c.messages.length ||
            p.sendError != c.sendError,
        // Rebuild message list (and _buildStatusIcon) when bloc emits updated messages (e.g. after HubMessageStatusChanged or HubConversationSeen).
        buildWhen: (p, c) =>
            p.messages != c.messages ||
            p.messagesLoading != c.messagesLoading ||
            p.messagesLoadingMore != c.messagesLoadingMore ||
            p.messagesError != c.messagesError ||
            p.isSending != c.isSending ||
            p.typingInfo != c.typingInfo ||
            p.hubConnected != c.hubConnected ||
            p.hubReconnecting != c.hubReconnecting,
        listener: (_, state) {
          if (state.sendError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.sendError!),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }

          // add notifySeen here
          if (state.messagesLoading == false &&
              state.messages.last.isMe == false) {
            log(
              '👁️ notifySeen to: ${state.messages.last.senderId} (id: ${state.messages.last.id}, isMe: ${state.messages.last.isMe} , groupId: ${widget.chat.isGroup ? widget.chat.id : null})',
            );
            context.read<ChatBloc>().add(
              NotifySeenEvent(
                senderId: state.messages.last.senderId,
                groupId: widget.chat.isGroup ? widget.chat.id : null,
              ),
            );
          }

          if (state.messages.isNotEmpty && !state.messagesLoadingMore) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
          }
        },
        builder: (_, state) {
          final isTypingInThisChat =
              state.typingInfo?.isTyping == true &&
              (widget.chat.isGroup
                  ? widget.chat.members.any(
                      (m) => m.userId == state.typingInfo?.userId,
                    )
                  : widget.chat.id == state.typingInfo?.userId);
          final showHubBanner = !state.hubConnected || state.hubReconnecting;
          return Column(
            children: [
              if (showHubBanner)
                _ChatSignalRBanner(
                  hubReconnecting: state.hubReconnecting,
                  hubError: state.hubError,
                ),
              Expanded(child: _buildMessageList(state)),
              if (isTypingInThisChat)
                _TypingIndicator(userName: _getTypingUserName(state)),
              _MessageInputBar(
                controller: _inputController,
                isSending: state.isSending,
                onChanged: _onTextChanged,
                onSend: _sendMessage,
              ),
            ],
          );
        },
      ),
    );
  }
}
