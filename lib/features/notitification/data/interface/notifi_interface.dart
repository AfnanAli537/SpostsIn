import 'package:sports_in/features/notitification/data/model/notifi_model.dart';

abstract class NotificationRemoteDataSource {
  /// ✅ GET /api/Notification
  /// [category] optional filter: "requests" | "reactions" | "opportunities" | "recent"
  Future<PaginatedNotificationsResponse> getNotifications({
    int pageNumber = 1,
    int pageSize = 20,
    String? category,
  });

  /// ✅ GET /api/Notification/unread-count
  Future<int> getUnreadCount();

  /// ✅ PUT /api/Notification/{id}/read
  Future<void> markAsRead({required String id});

  /// ✅ PUT /api/Notification/read-all
  Future<void> markAllAsRead();
}