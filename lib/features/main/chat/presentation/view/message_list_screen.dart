import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/features/main/chat/data/models/chat_models.dart';
import 'package:sports_in/features/main/chat/presentation/view/chat_screen.dart';
import 'package:sports_in/features/main/chat/presentation/view/create_group_screen.dart';
import 'package:sports_in/features/main/chat/presentation/view/widgets/chat_widget.dart';
import 'package:sports_in/features/main/chat/presentation/manger/chat_bloc/chat_bloc.dart';

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

    context.read<ChatBloc>().add(HubConnectEvent());

    context.read<ChatBloc>().add(LoadChatsEvent());
    context.read<ChatBloc>().add(LoadContactsEvent());

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
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Messages',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          BlocBuilder<ChatBloc, ChatState>(
                            buildWhen: (p, c) =>
                                p.hubConnected != c.hubConnected,
                            builder: (_, state) => Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: state.hubConnected
                                    ? Colors.green
                                    : Colors.grey,
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

                BlocBuilder<ChatBloc, ChatState>(
                  buildWhen: (p, c) =>
                      p.contacts != c.contacts ||
                      p.contactsLoading != c.contactsLoading,
                  builder: (_, state) {
                    if (state.contactsLoading) {
                      return const SizedBox(
                        height: 94,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }
                    if (state.contacts.isEmpty) return const SizedBox.shrink();
                    return Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionLabel(text: 'Contacts'),
                          SizedBox(
                            height: 78,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              itemCount: state.contacts.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 16),
                              itemBuilder: (_, i) {
                                final c = state.contacts[i];
                                return GestureDetector(
                                  onTap: () {
                                    final chat = ChatModel(
                                      id: c.id,
                                      title: c.name,
                                      groupPhoto: c.avatar,
                                      isGroup: false,
                                      members: const [],
                                      lastMessage: null,
                                      lastMessageTime: null,
                                      unreadCount: 0,
                                      isOnline: c.isOnline,
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider.value(
                                          value: context.read<ChatBloc>(),
                                          child: ChatWindowScreen(chat: chat),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      ChatAvatar(
                                        imageUrl: c.avatar,
                                        name: c.name,
                                        size: 48,
                                        showOnline: c.isOnline,
                                      ),
                                      const SizedBox(height: 4),
                                      SizedBox(
                                        width: 52,
                                        child: Text(
                                          c.name.split(' ').first,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                          ),
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

                Expanded(
                  child: BlocConsumer<ChatBloc, ChatState>(
                    listenWhen: (p, c) => p.chatsError != c.chatsError,
                    listener: (_, state) {
                      if (state.chatsError != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.chatsError!),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                    buildWhen: (p, c) =>
                        p.chats != c.chats ||
                        p.chatsLoading != c.chatsLoading ||
                        p.chatsLoadingMore != c.chatsLoadingMore ||
                        p.searchQuery != c.searchQuery ||
                        p.searchResult != c.searchResult,
                    builder: (_, state) {
                      if (state.chatsLoading && state.chats.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      List<Widget> buildList(List<ChatModel> chats) {
                        if (chats.isEmpty) {
                          return const [Expanded(child: _EmptyChatsView())];
                        }
                        return [
                          Expanded(
                            child: RefreshIndicator(
                              color: Colors.blue,
                              onRefresh: () async => context
                                  .read<ChatBloc>()
                                  .add(LoadChatsEvent(isRefresh: true)),
                              child: ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.only(
                                  bottom: 100,
                                  top: 4,
                                ),
                                itemCount:
                                    chats.length +
                                    (state.chatsLoadingMore ? 1 : 0),
                                itemBuilder: (_, i) {
                                  if (i == chats.length) {
                                    return const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    );
                                  }
                                  final chat = chats[i];
                                  return _ChatTile(
                                    chat: chat,
                                    timeLabel: _formatTime(
                                      chat.lastMessageTime,
                                    ),
                                    isOnline: chat.isOnline,
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider.value(
                                          value: context.read<ChatBloc>(),
                                          child: ChatWindowScreen(
                                            chat: chats[i],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ];
                      }

                      if ((state.searchQuery ?? '').isNotEmpty) {
                        final results = state.searchResult
                            .map(
                              (s) => ChatModel(
                                id: s.id,
                                title: s.title,
                                groupPhoto: s.imageUrl,
                                isGroup: s.type.toLowerCase() == 'group',
                                members: const [],
                                lastMessage: null,
                                lastMessageTime: null,
                                unreadCount: 0,
                                isOnline: s.isOnline,
                              ),
                            )
                            .toList();
                        return Column(children: buildList(results));
                      }

                      return Column(children: buildList(state.chats));
                    },
                  ),
                ),
              ],
            ),

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
                          MaterialPageRoute(
                            builder: (_) => const CreateGroupScreen(),
                          ),
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
                            colors: [Colors.blue, Colors.indigo],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
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
    final theme = Theme.of(context);
    final hasUnread = chat.unreadCount > 0;
    final preview = chat.lastMessage ?? '';

    return InkWell(
      onTap: onTap,
      splashColor: theme.colorScheme.primary.withOpacity(0.05),
      highlightColor: theme.dividerColor.withOpacity(0.4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            ChatAvatar(
              imageUrl: chat.groupPhoto,
              name: chat.title ?? 'Chat',
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
                          chat.title ?? 'Chat',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: hasUnread
                                ? FontWeight.w800
                                : FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        timeLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: hasUnread
                              ? theme.colorScheme.primary
                              : theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          preview,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: hasUnread
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: hasUnread
                                ? theme.colorScheme.onSurface
                                : theme.hintColor,
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

class _EmptyChatsView extends StatelessWidget {
  const _EmptyChatsView();

  @override
  Widget build(BuildContext context) => const Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.chat_bubble_outline_rounded, size: 56, color: Colors.grey),
        SizedBox(height: 12),
        Text(
          'No messages yet',
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ],
    ),
  );
}

class _FabOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FabOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    ),
  );
}
