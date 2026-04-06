import 'package:injectable/injectable.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/network/endpoints.dart';
import 'package:sports_in/features/notitification/data/interface/notifi_interface.dart';
import 'package:sports_in/features/notitification/data/model/notifi_model.dart';
@LazySingleton(as: NotificationRemoteDataSource)
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient _apiClient;

  NotificationRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  ///✅ ─── Get Notifications ───────────────────────────────────────────────────
  @override
  Future<PaginatedNotificationsResponse> getNotifications({
    int pageNumber = 1,
    int pageSize = 20,
    String? category,
  }) async {
    final response = await _apiClient.get(
      Endpoints.getNotifications,
      params: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        if (category != null) 'category': category,
      },
    );

    return PaginatedNotificationsResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  ///✅ ─── Get Unread Count ────────────────────────────────────────────────────
  @override
  Future<int> getUnreadCount() async {
    final response = await _apiClient.get(Endpoints.getUnreadCount);
    final data = response.data;
    if (data is int) return data;
    if (data is Map) return (data['unreadCount'] as int?) ?? 0;
    return 0;
  }

  ///✅ ─── Mark As Read ────────────────────────────────────────────────────────
  @override
  Future<void> markAsRead({required String id}) async {
    final url = Endpoints.markNotificationAsRead.replaceFirst('{id}', id);
    await _apiClient.put(url);
  }

  ///✅ ─── Mark All As Read ────────────────────────────────────────────────────
  @override
  Future<void> markAllAsRead() async {
    await _apiClient.put(Endpoints.markAllNotificationsAsRead);
  }
}