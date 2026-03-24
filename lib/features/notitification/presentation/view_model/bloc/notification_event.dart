part of 'notification_bloc.dart';

sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}



/// Fetch first page — optional category filter
class GetNotificationsEvent extends NotificationEvent {
  final String? category; // "requests" | "reactions" | "opportunities" | "recent" | null = all
  const GetNotificationsEvent({this.category});

  @override
  List<Object?> get props => [category];
}

/// Fetch next page (pagination)
class LoadMoreNotificationsEvent extends NotificationEvent {
  const LoadMoreNotificationsEvent();
}

/// Fetch unread badge count
class GetUnreadCountEvent extends NotificationEvent {
  const GetUnreadCountEvent();
}

/// Mark single notification as read
class MarkAsReadEvent extends NotificationEvent {
  final String id;
  const MarkAsReadEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Mark all notifications as read
class MarkAllAsReadEvent extends NotificationEvent {
  const MarkAllAsReadEvent();
}

/// Called from SignalR hub when a real-time notification arrives
class RealtimeNotificationReceivedEvent extends NotificationEvent {
  final NotificationModel notification;
  const RealtimeNotificationReceivedEvent({required this.notification});

  @override
  List<Object?> get props => [notification];
}