import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sports_in/features/notitification/data/model/notifi_model.dart';
import 'package:sports_in/features/notitification/presentation/view_model/bloc/notification_bloc.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<NotificationBloc>()
        ..add(const GetNotificationsEvent())
        ..add(const GetUnreadCountEvent()),
      child: const _NotificationView(),
    );
  }
}

class _NotificationView extends StatefulWidget {
  const _NotificationView();

  @override
  State<_NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<_NotificationView> {
  final ScrollController _scrollController = ScrollController();
  String? _activeCategory; // null = Recent

  static const _categories = [
    {'label': 'Recent', 'value': null},
    {'label': 'Requests', 'value': 'requests'},
    {'label': 'Reactions', 'value': 'reactions'},
    {'label': 'Opportunities', 'value': 'opportunities'},
  ];

  // ─── Category color helpers ────────────────────────────────────────────────
  static const _primaryGreen = Color(0xFF3DBE6C);
  static const _bgColor = Color(0xFFF7F8FA);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NotificationBloc>().add(const LoadMoreNotificationsEvent());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _switchCategory(String? value) {
    setState(() => _activeCategory = value);
    context.read<NotificationBloc>().add(
          GetNotificationsEvent(category: value),
        );
  }

  // ─── Group notifications by date ──────────────────────────────────────────
  Map<String, List<NotificationModel>> _groupByDate(
      List<NotificationModel> items) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final Map<String, List<NotificationModel>> grouped = {};
    for (final n in items) {
      final d = DateTime(n.createdAt.year, n.createdAt.month, n.createdAt.day);
      String label;
      if (d == today) {
        label =
            'Today, ${_monthName(d.month)} ${d.day}';
      } else if (d == yesterday) {
        label = 'Yesterday';
      } else {
        label = '${_monthName(d.month)} ${d.day}';
      }
      grouped.putIfAbsent(label, () => []).add(n);
    }
    return grouped;
  }

  String _monthName(int m) => const [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m];

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }

  // ─── Icon & color per notification type ───────────────────────────────────
  Color _typeColor(String type) {
    return switch (type) {
      'OpportunityNew' || 'OpportunityAccepted' => const Color(0xFF3DBE6C),
      'OpportunityRejected' => const Color(0xFFE05C5C),
      'PostLike' || 'AdLike' => const Color(0xFFFF7043),
      'PostComment' => const Color(0xFF42A5F5),
      'ConnectionRequest' || 'ConnectionAccepted' => const Color(0xFF7E57C2),
      'Follow' => const Color(0xFFEC407A),
      'GroupInvitation' => const Color(0xFF26C6DA),
      _ => const Color(0xFF90A4AE),
    };
  }

  IconData _typeIcon(String type) {
    return switch (type) {
      'OpportunityNew' => Icons.work_outline_rounded,
      'OpportunityAccepted' => Icons.check_circle_outline_rounded,
      'OpportunityRejected' => Icons.cancel_outlined,
      'OpportunityApplied' => Icons.send_rounded,
      'PostLike' || 'AdLike' => Icons.favorite_border_rounded,
      'PostComment' => Icons.chat_bubble_outline_rounded,
      'ConnectionRequest' => Icons.person_add_alt_1_outlined,
      'ConnectionAccepted' => Icons.people_outline_rounded,
      'Follow' => Icons.person_outline_rounded,
      'GroupInvitation' => Icons.group_add_outlined,
      _ => Icons.notifications_none_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          _buildCategoryBar(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  // ─── AppBar ────────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            size: 18, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Notification',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      actions: [
        BlocBuilder<NotificationBloc, NotificationState>(
          buildWhen: (_, s) => s is NotificationsLoaded,
          builder: (context, state) {
            final count = state is NotificationsLoaded ? state.unreadCount : 0;
            if (count == 0) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsets.only(right: 16),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _primaryGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$count new',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            );
          },
        ),
      ],
    );
  }

  // ─── Category Filter Bar ───────────────────────────────────────────────────
  Widget _buildCategoryBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _categories.map((cat) {
            final isActive = _activeCategory == cat['value'];
            return GestureDetector(
              onTap: () => _switchCategory(cat['value'] as String?),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? _primaryGreen : const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  cat['label'] as String,
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.black54,
                    fontWeight:
                        isActive ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ─── Body ──────────────────────────────────────────────────────────────────
  Widget _buildBody() {
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is NotificationsLoading) {
          return const Center(
            child: CircularProgressIndicator(color: _primaryGreen),
          );
        }

        if (state is NotificationsLoaded) {
          if (state.notifications.isEmpty) {
            return _buildEmpty();
          }
          return _buildList(state);
        }

        if (state is NotificationsError) {
          return _buildError(state.message);
        }

        return const SizedBox.shrink();
      },
    );
  }

  // ─── Notification List ─────────────────────────────────────────────────────
  Widget _buildList(NotificationsLoaded state) {
    final grouped = _groupByDate(state.notifications);

    return RefreshIndicator(
      color: _primaryGreen,
      onRefresh: () async {
        context.read<NotificationBloc>().add(
              GetNotificationsEvent(category: _activeCategory),
            );
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: grouped.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == grouped.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: CircularProgressIndicator(color: _primaryGreen),
              ),
            );
          }

          final dateLabel = grouped.keys.elementAt(index);
          final items = grouped[dateLabel]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateHeader(dateLabel, items),
              ...items.map((n) => _buildNotificationTile(n)),
            ],
          );
        },
      ),
    );
  }

  // ─── Date Header ──────────────────────────────────────────────────────────
  Widget _buildDateHeader(String label, List<NotificationModel> items) {
    final hasUnread = items.any((n) => !n.isRead);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          if (hasUnread)
            GestureDetector(
              onTap: () => context
                  .read<NotificationBloc>()
                  .add(const MarkAllAsReadEvent()),
              child: const Text(
                'Mark all as read',
                style: TextStyle(
                  color: _primaryGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── Notification Tile ─────────────────────────────────────────────────────
  Widget _buildNotificationTile(NotificationModel n) {
    final color = _typeColor(n.type);
    final icon = _typeIcon(n.type);
    final isInvitation = n.type == 'GroupInvitation';

    return GestureDetector(
      onTap: () {
        if (!n.isRead) {
          context.read<NotificationBloc>().add(MarkAsReadEvent(id: n.id));
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: n.isRead ? Colors.white : color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: n.isRead ? Colors.transparent : color.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar / Icon
              _buildAvatar(n, color, icon),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            n.title,
                            style: TextStyle(
                              fontWeight: n.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Text(
                          _timeAgo(n.createdAt),
                          style: const TextStyle(
                              fontSize: 11, color: Colors.black38),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      n.body,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Action buttons for GroupInvitation
                    if (isInvitation) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _actionButton('Accept', _primaryGreen, Colors.white),
                          const SizedBox(width: 8),
                          _actionButton(
                              'Reject', const Color(0xFFFFEBEE), Colors.red),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              // Unread dot
              if (!n.isRead)
                Padding(
                  padding: const EdgeInsets.only(left: 6, top: 4),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(NotificationModel n, Color color, IconData icon) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color.withOpacity(0.12),
          backgroundImage:
              n.senderImage != null ? NetworkImage(n.senderImage!) : null,
          child: n.senderImage == null
              ? Icon(icon, color: color, size: 22)
              : null,
        ),
      ],
    );
  }

  Widget _actionButton(String label, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: textColor, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  // ─── Empty State ───────────────────────────────────────────────────────────
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _primaryGreen.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_off_outlined,
              size: 48,
              color: _primaryGreen,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No notifications yet',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54),
          ),
          const SizedBox(height: 6),
          const Text(
            "You're all caught up!",
            style: TextStyle(fontSize: 13, color: Colors.black38),
          ),
        ],
      ),
    );
  }

  // ─── Error State ───────────────────────────────────────────────────────────
  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.black26),
          const SizedBox(height: 12),
          Text(message,
              style: const TextStyle(color: Colors.black45, fontSize: 13)),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => context.read<NotificationBloc>().add(
                  GetNotificationsEvent(category: _activeCategory),
                ),
            child: const Text('Retry',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}