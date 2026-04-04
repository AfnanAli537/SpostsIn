import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/app/routes/app_routes.dart';
import 'package:sports_in/features/main/opportunity/data/repo/opportunity_repo.dart';
import 'package:sports_in/features/main/opportunity/view/presentation/details.dart';
import 'package:sports_in/features/main/opportunity/view_model/opportunity_bloc/opportunity_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/connection%20bloc/connections_bloc.dart';
import 'package:sports_in/features/main/profile/view_model/connection%20bloc/connections_event.dart';
import 'package:sports_in/features/notitification/data/model/notifi_model.dart';
import 'package:sports_in/features/notitification/presentation/view_model/bloc/notification_bloc.dart';

// ─── Navigation routing maps ───────────────────────────────────────────────────
const _profileTypes = {
  'ConnectionRequest',
  'ConnectionAccepted',
  'Follow',
  'GroupInvitation',
};
const _postTypes = {'PostLike', 'PostComment', 'AdLike'};
const _opportunityTypes = {
  'OpportunityNew',
  'OpportunityApplied',
  'OpportunityAccepted',
  'OpportunityRejected',
};
const _connectionTypes = {'ConnectionRequest', 'GroupInvitation'};

class NotificationScreen extends StatelessWidget {
  /// THE FIX: Accept the existing NotificationBloc as a constructor parameter.
  ///
  /// WHY: Navigator.push() creates a brand-new route with its own BuildContext
  /// that is completely outside the BlocProvider tree of CustomBottomNav.
  /// Calling context.read<NotificationBloc>() inside build() of this screen
  /// throws ProviderNotFoundException because that context has no ancestor
  /// BlocProvider<NotificationBloc>.
  ///
  /// By passing the bloc explicitly from the CALLER (CustomBottomNav) where
  /// the context DOES have the provider, we reuse the exact same instance that
  /// receives SignalR real-time events — so this screen updates live.
  final NotificationBloc notificationBloc;

  const NotificationScreen({super.key, required this.notificationBloc});

  @override
  Widget build(BuildContext context) {
    // Trigger a fresh load on the shared bloc instance
    notificationBloc
      ..add(const GetNotificationsEvent())
      ..add(const GetUnreadCountEvent());

    return MultiBlocProvider(
      providers: [
        // BlocProvider.value reuses the instance WITHOUT closing it on pop —
        // correct because CustomBottomNav (the owner) is still alive
        BlocProvider.value(value: notificationBloc),
        // ConnectionsBloc is only needed inside this screen, create fresh
        BlocProvider(create: (_) => GetIt.I<ConnectionsBloc>()),
      ],
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
  String? _activeCategory;

  static const _primaryGreen = Color(0xFF3DBE6C);
  static const _bgColor = Color(0xFFF7F8FA);

  static const _categories = [
    {'label': 'Recent', 'value': 'recent'},
    {'label': 'Requests', 'value': 'requests'},
    {'label': 'Reactions', 'value': 'reactions'},
    {'label': 'Opportunities', 'value': 'opportunities'},
  ];

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
    context
        .read<NotificationBloc>()
        .add(GetNotificationsEvent(category: value));
  }

  // ─── Smart navigation ──────────────────────────────────────────────────────
  void _navigate(NotificationModel n) {
    final id = n.relatedEntityId;
    if (id == null) return;
    if (_profileTypes.contains(n.type)) {
      Navigator.pushNamed(context, AppRoutes.userProfile, arguments: id);
    } else if (_postTypes.contains(n.type)) {
      Navigator.pushNamed(context, AppRoutes.postDetail, arguments: id);
    } else if (_opportunityTypes.contains(n.type)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => OpportunityBloc(
              opportunityRepo: getIt<OpportunityReposatory>(),
            ),
            child: OpportunityDetailsPage(opportunityId: id, isOwner: true),
          ),
        ),
      );
    }
  }

  void _markAndNavigate(NotificationModel n) {
    if (!n.isRead) {
      context.read<NotificationBloc>().add(MarkAsReadEvent(id: n.id));
    }
    _navigate(n);
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────
  Map<String, List<NotificationModel>> _groupByDate(
      List<NotificationModel> items) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final grouped = <String, List<NotificationModel>>{};
    for (final n in items) {
      final d = DateTime(n.createdAt.year, n.createdAt.month, n.createdAt.day);
      final String label;
      if (d == today) {
        label = 'Today, ${_monthName(d.month)} ${d.day}';
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
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ][m];

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }

  Color _typeColor(String type) => switch (type) {
        'OpportunityNew' || 'OpportunityAccepted' => const Color(0xFF3DBE6C),
        'OpportunityRejected' => const Color(0xFFE05C5C),
        'PostLike' || 'AdLike' => const Color(0xFFFF7043),
        'PostComment' => const Color(0xFF42A5F5),
        'ConnectionRequest' || 'ConnectionAccepted' => const Color(0xFF7E57C2),
        'Follow' => const Color(0xFFEC407A),
        'GroupInvitation' => const Color(0xFF26C6DA),
        _ => const Color(0xFF90A4AE),
      };

  IconData _typeIcon(String type) => switch (type) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: _buildAppBar(),
      body: Column(children: [
        _buildCategoryBar(),
        Expanded(child: _buildBody()),
      ]),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            size: 18, color: Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('Notification',
          style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
              fontSize: 18)),
      actions: [
        BlocBuilder<NotificationBloc, NotificationState>(
          buildWhen: (_, s) => s is NotificationsLoaded,
          builder: (context, state) {
            final count =
                state is NotificationsLoaded ? state.unreadCount : 0;
            if (count == 0) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsets.only(right: 16),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: _primaryGreen,
                  borderRadius: BorderRadius.circular(20)),
              child: Text('$count new',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            );
          },
        ),
      ],
    );
  }

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
              onTap: () => _switchCategory(cat['value']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? _primaryGreen : const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(cat['label'] as String,
                    style: TextStyle(
                        color: isActive ? Colors.white : Colors.black54,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.w500,
                        fontSize: 13)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocConsumer<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationsError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating));
        }
      },
      builder: (context, state) {
        if (state is NotificationsLoading) {
          return const Center(
              child: CircularProgressIndicator(color: _primaryGreen));
        }
        if (state is NotificationsLoaded) {
          if (state.notifications.isEmpty) return _buildEmpty();
          return _buildList(state);
        }
        if (state is NotificationsError) return _buildError(state.message);
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildList(NotificationsLoaded state) {
    final grouped = _groupByDate(state.notifications);
    return RefreshIndicator(
      color: _primaryGreen,
      onRefresh: () async => context.read<NotificationBloc>().add(
            GetNotificationsEvent(category: _activeCategory),
          ),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: grouped.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == grouped.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                  child: CircularProgressIndicator(color: _primaryGreen)),
            );
          }
          final dateLabel = grouped.keys.elementAt(index);
          final items = grouped[dateLabel]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateHeader(dateLabel, items),
              ...items.map(_buildNotificationTile),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDateHeader(String label, List<NotificationModel> items) {
    final hasUnread = items.any((n) => !n.isRead);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                  fontSize: 14)),
          if (hasUnread)
            GestureDetector(
              onTap: () => context
                  .read<NotificationBloc>()
                  .add(const MarkAllAsReadEvent()),
              child: const Text('Mark all as read',
                  style: TextStyle(
                      color: _primaryGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(NotificationModel n) {
    return _connectionTypes.contains(n.type)
        ? _ConnectionTile(
            n: n,
            timeAgo: _timeAgo(n.createdAt),
            color: _typeColor(n.type),
            icon: _typeIcon(n.type),
            onCardTap: () => _markAndNavigate(n),
            onMarkRead: () {
              if (!n.isRead) {
                context
                    .read<NotificationBloc>()
                    .add(MarkAsReadEvent(id: n.id));
              }
            },
            onAccept: () {
              if (!n.isRead) {
                context
                    .read<NotificationBloc>()
                    .add(MarkAsReadEvent(id: n.id));
              }
              context.read<ConnectionsBloc>().add(
                    RespondToRequest(
                        senderId: n.senderId!, status: 'Accepted'),
                  );
            },
            onReject: () {
              if (!n.isRead) {
                context
                    .read<NotificationBloc>()
                    .add(MarkAsReadEvent(id: n.id));
              }
              context.read<ConnectionsBloc>().add(
                    RespondToRequest(
                        senderId: n.senderId!, status: 'Rejected'),
                  );
            },
          )
        : _DefaultTile(
            n: n,
            timeAgo: _timeAgo(n.createdAt),
            color: _typeColor(n.type),
            icon: _typeIcon(n.type),
            onTap: () => _markAndNavigate(n),
          );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
              color: _primaryGreen.withOpacity(0.08), shape: BoxShape.circle),
          child: const Icon(Icons.notifications_off_outlined,
              size: 48, color: _primaryGreen),
        ),
        const SizedBox(height: 16),
        const Text('No notifications yet',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54)),
        const SizedBox(height: 6),
        const Text("You're all caught up!",
            style: TextStyle(fontSize: 13, color: Colors.black38)),
      ]),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.black26),
        const SizedBox(height: 12),
        Text(message,
            style: const TextStyle(color: Colors.black45, fontSize: 13)),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: _primaryGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          onPressed: () => context.read<NotificationBloc>().add(
                GetNotificationsEvent(category: _activeCategory),
              ),
          child: const Text('Retry', style: TextStyle(color: Colors.white)),
        ),
      ]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Default Tile
// ─────────────────────────────────────────────────────────────────────────────
class _DefaultTile extends StatelessWidget {
  final NotificationModel n;
  final String timeAgo;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _DefaultTile({
    required this.n,
    required this.timeAgo,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: n.isRead ? Colors.white : color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: n.isRead ? Colors.transparent : color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(n: n, color: color, icon: icon),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (n.senderName != null)
                              Text(n.senderName!,
                                  style: TextStyle(
                                      fontWeight: n.isRead
                                          ? FontWeight.w600
                                          : FontWeight.w700,
                                      fontSize: 13,
                                      color: Colors.black87)),
                            Text(n.title,
                                style: TextStyle(
                                    fontWeight: n.isRead
                                        ? FontWeight.w400
                                        : FontWeight.w600,
                                    fontSize: 13,
                                    color: Colors.black54)),
                          ],
                        ),
                      ),
                      Text(timeAgo,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.black38)),
                    ]),
                    const SizedBox(height: 3),
                    Text(n.body,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54, height: 1.4),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              if (!n.isRead)
                Padding(
                  padding: const EdgeInsets.only(left: 6, top: 4),
                  child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          color: color, shape: BoxShape.circle)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Connection Tile — stateful for loading / done feedback
// ─────────────────────────────────────────────────────────────────────────────
class _ConnectionTile extends StatefulWidget {
  final NotificationModel n;
  final String timeAgo;
  final Color color;
  final IconData icon;
  final VoidCallback onCardTap;
  final VoidCallback onMarkRead;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const _ConnectionTile({
    required this.n,
    required this.timeAgo,
    required this.color,
    required this.icon,
    required this.onCardTap,
    required this.onMarkRead,
    required this.onAccept,
    required this.onReject,
  });

  @override
  State<_ConnectionTile> createState() => _ConnectionTileState();
}

class _ConnectionTileState extends State<_ConnectionTile> {
  static const _primaryGreen = Color(0xFF3DBE6C);
  String? _actionStatus;

  void _handleAccept() {
    if (_actionStatus != null) return;
    setState(() => _actionStatus = 'loading_accept');
    widget.onAccept();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _actionStatus = 'Accepted');
    });
  }

  void _handleReject() {
    if (_actionStatus != null) return;
    setState(() => _actionStatus = 'loading_reject');
    widget.onReject();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _actionStatus = 'Rejected');
    });
  }

  @override
  Widget build(BuildContext context) {
    final n = widget.n;
    final color = widget.color;

    return GestureDetector(
      onTap: widget.onCardTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: n.isRead ? Colors.white : color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: n.isRead ? Colors.transparent : color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(n: n, color: color, icon: widget.icon),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                        child: Text(
                          n.senderName ?? n.title,
                          style: TextStyle(
                              fontWeight: n.isRead
                                  ? FontWeight.w600
                                  : FontWeight.w700,
                              fontSize: 14,
                              color: Colors.black87),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(widget.timeAgo,
                          style: const TextStyle(
                              fontSize: 11, color: Colors.black38)),
                    ]),
                    const SizedBox(height: 3),
                    Text(n.body,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54, height: 1.4),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 10),
                    _buildActionArea(),
                  ],
                ),
              ),
              if (!n.isRead)
                Padding(
                  padding: const EdgeInsets.only(left: 6, top: 4),
                  child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          color: color, shape: BoxShape.circle)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionArea() {
    if (_actionStatus == 'Accepted') {
      return const _StatusChip(
        label: 'Request Accepted',
        icon: Icons.check_circle_rounded,
        color: _primaryGreen,
      );
    }
    if (_actionStatus == 'Rejected') {
      return const _StatusChip(
        label: 'Request Declined',
        icon: Icons.cancel_rounded,
        color: Colors.red,
      );
    }

    final isLoadingAccept = _actionStatus == 'loading_accept';
    final isLoadingReject = _actionStatus == 'loading_reject';

    return Row(children: [
      Expanded(
        child: FilledButton(
          onPressed:
              (isLoadingAccept || isLoadingReject) ? null : _handleAccept,
          style: FilledButton.styleFrom(
            backgroundColor: _primaryGreen,
            disabledBackgroundColor: _primaryGreen.withOpacity(0.6),
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
          child: isLoadingAccept
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : const Text('Accept',
                  style:
                      TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: OutlinedButton(
          onPressed:
              (isLoadingAccept || isLoadingReject) ? null : _handleReject,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            disabledForegroundColor: Colors.red.withOpacity(0.4),
            side: BorderSide(
                color: (isLoadingAccept || isLoadingReject)
                    ? const Color(0xFFFFCDD2).withOpacity(0.4)
                    : const Color(0xFFFFCDD2)),
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
          child: isLoadingReject
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.red))
              : const Text('Reject',
                  style:
                      TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ),
      ),
    ]);
  }
}

// ─── Status chip ──────────────────────────────────────────────────────────────
class _StatusChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _StatusChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─── Shared avatar ────────────────────────────────────────────────────────────
class _Avatar extends StatelessWidget {
  final NotificationModel n;
  final Color color;
  final IconData icon;
  const _Avatar({required this.n, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: color.withOpacity(0.12),
      backgroundImage:
          n.senderImage != null ? NetworkImage(n.senderImage!) : null,
      child: n.senderImage == null ? Icon(icon, color: color, size: 22) : null,
    );
  }
}