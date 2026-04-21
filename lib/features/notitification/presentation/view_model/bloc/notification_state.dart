part of 'notification_bloc.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();
  
  @override
  List<Object?> get props => [];
}

// ── Initial ────────────────────────────────────────────────────────────────────
class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

// ── Loading (first page) ───────────────────────────────────────────────────────
class NotificationsLoading extends NotificationState {
  const NotificationsLoading();
}

// ── Loaded ─────────────────────────────────────────────────────────────────────
class NotificationsLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  final bool hasNextPage;
  final bool isLoadingMore;
  final int unreadCount;
  final String? activeCategory;

  const NotificationsLoaded({
    required this.notifications,
    required this.hasNextPage,
    this.isLoadingMore = false,
    required this.unreadCount,
    this.activeCategory,
  });

  NotificationsLoaded copyWith({
    List<NotificationModel>? notifications,
    bool? hasNextPage,
    bool? isLoadingMore,
    int? unreadCount,
    String? activeCategory,
  }) {
    return NotificationsLoaded(
      notifications: notifications ?? this.notifications,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      unreadCount: unreadCount ?? this.unreadCount,
      activeCategory: activeCategory ?? this.activeCategory,
    );
  }

  @override
  List<Object?> get props =>
      [notifications, hasNextPage, isLoadingMore, unreadCount, activeCategory];
}

// ── Error ──────────────────────────────────────────────────────────────────────
class NotificationsError extends NotificationState {
  final String message;
  const NotificationsError({required this.message});

  @override
  List<Object?> get props => [message];
}

// ── Mark As Read Success ───────────────────────────────────────────────────────
class MarkAsReadSuccess extends NotificationState {
  const MarkAsReadSuccess();
}

// ── Mark All As Read Success ───────────────────────────────────────────────────
class MarkAllAsReadSuccess extends NotificationState {
  const MarkAllAsReadSuccess();
}

// ── Unread Count Loaded ────────────────────────────────────────────────────────
class UnreadCountLoaded extends NotificationState {
  final int count;
  const UnreadCountLoaded({required this.count});

  @override
  List<Object?> get props => [count];
}