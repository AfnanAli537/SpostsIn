import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/features/main/chat/data/models/chat_model_import.dart';
import 'package:sports_in/features/main/chat/presentation/manger/chat_bloc/chat_bloc.dart';
import 'package:sports_in/features/main/chat/presentation/view/widgets/chat_avatar.dart';

part 'widgets/chat_view_widgets.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key, required this.chat});

  final ChatModel chat;

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
  String _currentUserName = 'Me';
  late SharedPref _sharedPref;
  late String _currentUserId;

  String? get _otherUserId => widget.chat.isGroup ? null : widget.chat.id;

  @override
  void initState() {
    super.initState();
    _initSharedPref();
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

  Future<void> _initSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    _sharedPref = SharedPref(prefs);
    await _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final user = await _sharedPref.getUserFromPrefs();
    if (!mounted) return;

    if (user?.name != null) {
      setState(() {
        _currentUserName = '${user!.name!.firstName} ${user.name!.secondName}'
            .trim();
      });
    }

    if (user?.userId != null) {
      setState(() {
        _currentUserId = user!.userId!;
      });
    }
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
        senderId: _currentUserId,
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
    bloc.add(MarkChatAsReadEvent(widget.chat.id));

    // Inform the hub so the other side can update statuses
    if (_otherUserId != null) {
      bloc.add(NotifySeenEvent(senderId: _otherUserId!));
    } else if (widget.chat.isGroup) {
      bloc.add(NotifySeenEvent(senderId: '', groupId: widget.chat.id));
    }
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

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
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
            isGroupChat: widget.chat.isGroup,
            isEditing: isEditing,
            editController: _editController,
            onLongPress: msg.isMe == true
                ? () => _showMessageOptions(context, msg)
                : null,
            onSaveEdit: _saveEdit,
            onCancelEdit: () => setState(() => _editingId = null),
            timeText: _formatTime(msg.sentAt),
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
        listener: (_, state) {
          if (state.sendError != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.sendError!),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }

          if (state.messages.isNotEmpty) {
            _scrollToBottom();
          }
        },
        builder: (_, state) {
          return Column(
            children: [
              Expanded(child: _buildMessageList(state)),
              if (state.typingInfo?.isTyping == true)
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
