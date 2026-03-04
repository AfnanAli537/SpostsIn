import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/features/main/chat/data/models/chat_models.dart';
import 'package:sports_in/features/main/chat/presentation/view/widgets/chat_widget.dart';
import 'package:sports_in/features/main/chat/presentation/manger/chat_bloc/chat_bloc.dart';

class ChatWindowScreen extends StatefulWidget {
  final ChatModel chat;
  const ChatWindowScreen({super.key, required this.chat});

  @override
  State<ChatWindowScreen> createState() => _ChatWindowScreenState();
}

class _ChatWindowScreenState extends State<ChatWindowScreen> {
  final _inputController = TextEditingController();
  final _editController = TextEditingController();
  final _scrollController = ScrollController();

  String? _editingId;
  Timer? _typingTimer;
  bool _isTyping = false;
  String _currentUserName = 'Me';
  late final SharedPref _sharedPref;
  late String _currentUserId;
  // For direct chat: other user's id
  String? get _otherUserId => widget.chat.isGroup ? null : widget.chat.id;
  // String? get _otherUserId =>
  //     widget.chat.isGroup ? null : widget.chat.members.firstOrNull?.userId;
  Future<void> _initSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    _sharedPref = SharedPref(prefs); // ✅ proper instance
    await _loadCurrentUser();
  }

  @override
  void initState() {
    super.initState();
    _initSharedPref();
    _loadMessages();
    // Pagination: load older messages on scroll to top
    _scrollController.addListener(() {
      if (_scrollController.position.pixels <= 100) {
        context.read<ChatBloc>().add(LoadMoreMessagesEvent());
      }
    });
  }

  Future<void> _loadCurrentUser() async {
    final user = await _sharedPref.getUserFromPrefs();
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
    // Reset typing timer
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
    } catch (_) {
      // If Bloc instance doesn't have handler (stale instance), ignore safely.
    }
  }

  void _notifySeen() {
    if (_otherUserId != null) {
      context.read<ChatBloc>().add(NotifySeenEvent(senderId: _otherUserId!));
    } else if (widget.chat.isGroup) {
      context.read<ChatBloc>().add(
        NotifySeenEvent(senderId: '', groupId: widget.chat.id),
      );
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
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: _buildAppBar(),
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
          // Scroll to bottom on new message
          if (state.messages.isNotEmpty) _scrollToBottom();
        },
        builder: (_, state) => Column(
          children: [
            Expanded(child: _buildMessageList(state)),
            // Typing indicator
            if (state.typingInfo?.isTyping == true)
              _TypingIndicator(userName: _getTypingUserName(state)),
            _buildInputBar(state),
          ],
        ),
      ),
    );
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leadingWidth: 40,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          size: 18,
          color: Colors.blue,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: BlocBuilder<ChatBloc, ChatState>(
        builder: (_, state) {
          final isOnline = !widget.chat.isGroup && widget.chat.isOnline;
          return Row(
            children: [
              ChatAvatar(
                imageUrl: widget.chat.groupPhoto,
                name: widget.chat.title ?? 'Chat',
                size: 38,
                showOnline: isOnline,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chat.title ?? 'Chat',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  BlocBuilder<ChatBloc, ChatState>(
                    buildWhen: (p, c) => p.typingInfo != c.typingInfo,
                    builder: (_, state) {
                      if (state.typingInfo?.isTyping == true) {
                        return const Text(
                          'typing...',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue,
                            fontStyle: FontStyle.italic,
                          ),
                        );
                      }
                      if (!widget.chat.isGroup && isOnline) {
                        return const Text(
                          'Online',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert_rounded, color: Colors.grey),
          onPressed: () {},
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: Color(0xFFEEF0F5)),
      ),
    );
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
          // Loading more indicator at top
          if (state.messagesLoadingMore && i == 0) {
            return const Padding(
              padding: EdgeInsets.all(8),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }
          final msgIndex = state.messagesLoadingMore ? i - 1 : i;
          return _buildMessageBubble(state.messages[msgIndex]);
        },
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel msg) {
    final isMe = msg.isMe == true;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            ChatAvatar(
              imageUrl: msg.senderAvatar,
              name: msg.senderName.isNotEmpty ? msg.senderName : 'User',
              size: 28,
            ),
            // ChatAvatar(imageUrl: msg.senderAvatar, name: msg.senderName, size: 28),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              child: _editingId == msg.id
                  ? _buildEditBubble()
                  : _buildNormalBubble(msg, isMe),
            ),
          ),
          if (isMe) const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildNormalBubble(MessageModel msg, bool isMe) {
    return GestureDetector(
      onLongPress: isMe ? () => _showMessageOptions(context, msg) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: isMe
              ? const LinearGradient(
                  colors: [Colors.blue, Colors.indigo],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isMe ? null : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: isMe
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.25)
                  : Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Show sender name in group chats
            if (widget.chat.isGroup && !isMe)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  msg.senderName,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue,
                  ),
                ),
              ),
            Text(
              msg.content,
              style: TextStyle(
                fontSize: 14,
                color: isMe ? Colors.white : Colors.black87,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (msg.isEdited)
                  Text(
                    'edited ',
                    style: TextStyle(
                      fontSize: 10,
                      color: isMe ? Colors.white60 : Colors.grey,
                    ),
                  ),
                Text(
                  _formatTime(msg.sentAt),
                  style: TextStyle(
                    fontSize: 10,
                    color: isMe ? Colors.white70 : Colors.grey,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 3),
                  Icon(
                    Icons.done_all_rounded,
                    size: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditBubble() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _editController,
            autofocus: true,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.blue, width: 2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _saveEdit,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () => setState(() => _editingId = null),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF0F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.close_rounded,
              size: 14,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputBar(ChatState state) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEF0F5))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.emoji_emotions_outlined,
              color: Colors.grey,
              size: 22,
            ),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _inputController,
              onChanged: _onTextChanged,
              onSubmitted: (_) => _sendMessage(),
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                filled: true,
                fillColor: Color(0xFFF7F8FC),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 11,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Color(0xFFEEF0F5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.attach_file_rounded,
              color: Colors.grey,
              size: 22,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
          ValueListenableBuilder(
            valueListenable: _inputController,
            builder: (_, val, __) {
              final hasText = val.text.trim().isNotEmpty;
              final isSending = state.isSending;
              return GestureDetector(
                onTap: isSending ? null : _sendMessage,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: hasText
                        ? const LinearGradient(
                            colors: [Colors.blue, Colors.indigo],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: hasText ? null : Color(0xFFEEF0F5),
                    boxShadow: hasText
                        ? [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: isSending
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          Icons.send_rounded,
                          size: 18,
                          color: hasText ? Colors.white : Colors.grey,
                        ),
                ),
              );
            },
          ),
        ],
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
                color: Color(0xFFEEF0F5),
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
}

// ─── Typing Indicator ─────────────────────────────────────────────────────────

class _TypingIndicator extends StatelessWidget {
  final String userName;
  const _TypingIndicator({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 4),
      child: Text(
        '$userName is typing...',
        style: const TextStyle(
          fontSize: 12,
          color: Colors.blue,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
