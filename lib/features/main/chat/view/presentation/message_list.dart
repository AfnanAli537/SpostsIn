import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/features/main/chat/data/models/chat_models.dart';
import 'package:sports_in/features/main/chat/view/presentation/chat_screen.dart';
import 'package:sports_in/features/main/chat/view/presentation/create_group.dart';
import 'package:sports_in/features/main/chat/view/widgets/chat_widget.dart';
import 'package:sports_in/features/main/chat/view/widgets/theme.dart';
import 'package:sports_in/features/main/chat/view_model/bloc/chat_bloc.dart';

class MessagesListScreen extends StatefulWidget {
  const MessagesListScreen({super.key});

  @override
  State<MessagesListScreen> createState() => _MessagesListScreenState();
}

class _MessagesListScreenState extends State<MessagesListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _fabExpanded = false;

  @override
  void initState() {
    super.initState();
    // Load chats on open
    context.read<ChatBloc>().add(LoadChatsEvent());
    context.read<ChatBloc>().add(LoadContactsEvent());

    // Pagination: load more when reaching bottom
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<ChatBloc>().add(LoadMoreChatsEvent());
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${dt.day}/${dt.month}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────────────────────────
                Container(
            
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                           Text('Messages', style: ChatTextStyles.heading),
                          const Spacer(),
                          // Hub connection indicator
                          BlocBuilder<ChatBloc, ChatState>(
                            buildWhen: (p, c) => p.hubConnected != c.hubConnected,
                            builder: (_, state) => Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: state.hubConnected ? ChatColors.online : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ChatSearchBar(
                        controller: _searchController,
                        onChanged: (v) =>
                            context.read<ChatBloc>().add(SearchChatsEvent(v)),
                      ),
                    ],
                  ),
                ),

                // ── Contacts Strip ───────────────────────────────────────
                BlocBuilder<ChatBloc, ChatState>(
                  buildWhen: (p, c) =>
                      p.contacts != c.contacts || p.contactsLoading != c.contactsLoading,
                  builder: (_, state) {
                    if (state.contactsLoading) {
                      return const SizedBox(
                        height: 94,
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      );
                    }
                    if (state.contacts.isEmpty) return const SizedBox.shrink();
                    return Container(
                      color: ChatColors.surface,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionLabel(text: 'Contacts'),
                          SizedBox(
                            height: 78,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              itemCount: state.contacts.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 16),
                              itemBuilder: (_, i) {
                                final c = state.contacts[i];
                                return GestureDetector(
                                  onTap: () => 
                                  Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => BlocProvider.value(
      value: context.read<ChatBloc>(),
      child: ChatWindowScreen(
        chat: ChatModel(
          id: c.userId,
          isGroup: false,
          members: [c],
          unreadCount: 0,
        ),
      ),
    
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (_) => ChatWindowScreen(
                                  //       chat: ChatModel(
                                  //         id: c.userId,
                                  //         isGroup: false,
                                  //         members: [c],
                                  //         unreadCount: 0,
                                  //       ),
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      ChatAvatar(
                                        imageUrl: c.avatar,
                                        name: c.userName,
                                        size: 48,
                                        showOnline: state.isUserOnline(c.userId),
                                      ),
                                      const SizedBox(height: 4),
                                      SizedBox(
                                        width: 52,
                                        child: Text(
                                          c.userName.split(' ').first,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 11, color: ChatColors.textSecondary),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    );
                  },
                ),

                const SectionLabel(text: 'All Messages'),

                // ── Chats List ───────────────────────────────────────────
                Expanded(
                  child: BlocConsumer<ChatBloc, ChatState>(
                    listenWhen: (p, c) => p.chatsError != c.chatsError,
                    listener: (_, state) {
                      if (state.chatsError != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.chatsError!),
                            backgroundColor: ChatColors.danger,
                          ),
                        );
                      }
                    },
                    buildWhen: (p, c) =>
                        p.chats != c.chats ||
                        p.chatsLoading != c.chatsLoading ||
                        p.chatsLoadingMore != c.chatsLoadingMore ||
                        p.onlineStatuses != c.onlineStatuses,
                    builder: (_, state) {
                      if (state.chatsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.chatsError != null && state.chats.isEmpty) {
                        return _ErrorView(
                          message: state.chatsError!,
                          onRetry: () => context.read<ChatBloc>().add(LoadChatsEvent()),
                        );
                      }

                      final chats = state.filteredChats;

                      if (chats.isEmpty) {
                        return const _EmptyChatsView();
                      }

                      return RefreshIndicator(
                        color: ChatColors.primary,
                        onRefresh: () async =>
                            context.read<ChatBloc>().add(LoadChatsEvent(isRefresh: true)),
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(bottom: 100),
                          itemCount: chats.length + (state.chatsLoadingMore ? 1 : 0),
                          itemBuilder: (_, i) {
                            if (i == chats.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                              );
                            }
                            return _ChatTile(
                              chat: chats[i],
                              timeLabel: _formatTime(chats[i].updatedAt),
                              isOnline: state.isUserOnline(
                                  chats[i].members.firstOrNull?.userId ?? ''),
                                 onTap: () =>  Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => BlocProvider.value(
      value: context.read<ChatBloc>(),
      child: ChatWindowScreen(chat: chats[i]),
    ),
  ),
),
                              // onTap: () => Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (_) => ChatWindowScreen(chat: chats[i]),
                              //   ),
                              // ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // ── FAB ──────────────────────────────────────────────────────
            Positioned(
              bottom: 24,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_fabExpanded) ...[
                    _FabOption(
                      icon: Icons.group_add_rounded,
                      label: 'Create Group',
                      onTap: () {
                        setState(() => _fabExpanded = false);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CreateGroupScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    _FabOption(
                      icon: Icons.person_add_rounded,
                      label: 'New Message',
                      onTap: () => setState(() => _fabExpanded = false),
                    ),
                    const SizedBox(height: 12),
                  ],
                  GestureDetector(
                    onTap: () => setState(() => _fabExpanded = !_fabExpanded),
                    child: AnimatedRotation(
                      turns: _fabExpanded ? 0.125 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [ChatColors.myBubbleStart, ChatColors.myBubbleEnd],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: ChatColors.primary.withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Chat Tile ────────────────────────────────────────────────────────────────

class _ChatTile extends StatelessWidget {
  final ChatModel chat;
  final String timeLabel;
  final bool isOnline;
  final VoidCallback onTap;

  const _ChatTile({
    required this.chat,
    required this.timeLabel,
    required this.isOnline,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasUnread = chat.unreadCount > 0;
    final preview = chat.lastMessage?.content ?? '';
    final isMe = chat.lastMessage?.senderId == 'me';

    return InkWell(
      onTap: onTap,
      splashColor: ChatColors.primary.withOpacity(0.05),
      highlightColor: ChatColors.border,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            ChatAvatar(
              imageUrl: chat.groupPhoto,
              name: chat.title!,
              size: 52,
              showOnline: !chat.isGroup && isOnline,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.title!,
                          style: ChatTextStyles.chatName.copyWith(
                            fontWeight: hasUnread ? FontWeight.w800 : FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        timeLabel,
                        style: ChatTextStyles.timestamp.copyWith(
                          color: hasUnread ? ChatColors.primary : ChatColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isMe ? 'You: $preview' : preview,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: ChatTextStyles.chatPreview.copyWith(
                            fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400,
                            color: hasUnread
                                ? ChatColors.textPrimary
                                : ChatColors.textSecondary,
                          ),
                        ),
                      ),
                      if (hasUnread) ...[
                        const SizedBox(width: 8),
                        UnreadBadge(count: chat.unreadCount),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty / Error / FAB helpers ─────────────────────────────────────────────

class _EmptyChatsView extends StatelessWidget {
  const _EmptyChatsView();

  @override
  Widget build(BuildContext context) => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_outline_rounded, size: 56, color: ChatColors.textMuted),
            SizedBox(height: 12),
            Text('No messages yet', style: TextStyle(color: ChatColors.textSecondary, fontSize: 15)),
          ],
        ),
      );
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48, color: ChatColors.danger),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: ChatColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(backgroundColor: ChatColors.primary),
            ),
          ],
        ),
      );
}

class _FabOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FabOption({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: ChatColors.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 16, offset: const Offset(0, 4))
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: ChatColors.primary),
              const SizedBox(width: 8),
              Text(label,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700, color: ChatColors.textPrimary)),
            ],
          ),
        ),
      );
}