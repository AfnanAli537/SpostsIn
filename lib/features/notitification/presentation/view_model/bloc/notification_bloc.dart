import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/features/notitification/data/model/notifi_model.dart';
import 'package:sports_in/features/notitification/data/repo/notifi_repo.dart';
part 'notification_event.dart';
part 'notification_state.dart';

// class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
//   NotificationBloc() : super(NotificationInitial()) {
//     on<NotificationEvent>((event, emit) {
//       // TODO: implement event handler
//     });
//   }
// }


@injectable
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _repository;

  int _currentPage = 1;
  bool _hasNextPage = false;
  String? _activeCategory;
  List<NotificationModel> _notifications = [];
  int _unreadCount = 0;

  NotificationBloc({required NotificationRepository repository})
      : _repository = repository,
        super(const NotificationInitial()) {
    on<GetNotificationsEvent>(_onGetNotifications);
    on<LoadMoreNotificationsEvent>(_onLoadMore);
    on<GetUnreadCountEvent>(_onGetUnreadCount);
    on<MarkAsReadEvent>(_onMarkAsRead);
    on<MarkAllAsReadEvent>(_onMarkAllAsRead);
    on<RealtimeNotificationReceivedEvent>(_onRealtimeNotification);
  }

  // ── Get Notifications ──────────────────────────────────────────────────────
  Future<void> _onGetNotifications(
    GetNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    // Reset pagination on fresh load
    _currentPage = 1;
    _activeCategory = event.category;
    _notifications = [];

    emit(const NotificationsLoading());

    final result = await _repository.getNotifications(
      pageNumber: _currentPage,
      pageSize: 20,
      category: _activeCategory,
    );

    result.fold(
      (error) => emit(NotificationsError(message: error.message)),
      (data) {
        _notifications = data.items;
        _hasNextPage = data.hasNextPage;
        emit(NotificationsLoaded(
          notifications: List.from(_notifications),
          hasNextPage: _hasNextPage,
          unreadCount: _unreadCount,
          activeCategory: _activeCategory,
        ));
      },
    );
  }

  // ── Load More (Pagination) ─────────────────────────────────────────────────
  Future<void> _onLoadMore(
    LoadMoreNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    if (!_hasNextPage) return;
    if (state is! NotificationsLoaded) return;

    final currentState = state as NotificationsLoaded;
    emit(currentState.copyWith(isLoadingMore: true));

    _currentPage++;
    final result = await _repository.getNotifications(
      pageNumber: _currentPage,
      pageSize: 20,
      category: _activeCategory,
    );

    result.fold(
      (error) {
        _currentPage--;
        emit(currentState.copyWith(isLoadingMore: false));
      },
      (data) {
        _notifications = [..._notifications, ...data.items];
        _hasNextPage = data.hasNextPage;
        emit(NotificationsLoaded(
          notifications: List.from(_notifications),
          hasNextPage: _hasNextPage,
          isLoadingMore: false,
          unreadCount: _unreadCount,
          activeCategory: _activeCategory,
        ));
      },
    );
  }

  // ── Get Unread Count ───────────────────────────────────────────────────────
  Future<void> _onGetUnreadCount(
    GetUnreadCountEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _repository.getUnreadCount();
    result.fold(
      (_) {},
      (count) {
        _unreadCount = count;
        emit(UnreadCountLoaded(count: count));
        // Also update loaded state if active
        if (state is NotificationsLoaded) {
          emit((state as NotificationsLoaded).copyWith(unreadCount: count));
        }
      },
    );
  }

  // ── Mark As Read ───────────────────────────────────────────────────────────
  Future<void> _onMarkAsRead(
    MarkAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _repository.markAsRead(id: event.id);
    result.fold(
      (error) => emit(NotificationsError(message: error.message)),
      (_) {
        // Update locally without re-fetching
        _notifications = _notifications.map((n) {
          return n.id == event.id ? n.copyWith(isRead: true) : n;
        }).toList();
        if (_unreadCount > 0) _unreadCount--;

        emit(const MarkAsReadSuccess());
        emit(NotificationsLoaded(
          notifications: List.from(_notifications),
          hasNextPage: _hasNextPage,
          unreadCount: _unreadCount,
          activeCategory: _activeCategory,
        ));
      },
    );
  }

  // ── Mark All As Read ───────────────────────────────────────────────────────
  Future<void> _onMarkAllAsRead(
    MarkAllAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final result = await _repository.markAllAsRead();
    result.fold(
      (error) => emit(NotificationsError(message: error.message)),
      (_) {
        _notifications =
            _notifications.map((n) => n.copyWith(isRead: true)).toList();
        _unreadCount = 0;

        emit(const MarkAllAsReadSuccess());
        emit(NotificationsLoaded(
          notifications: List.from(_notifications),
          hasNextPage: _hasNextPage,
          unreadCount: 0,
          activeCategory: _activeCategory,
        ));
      },
    );
  }

  // ── Real-time Notification (SignalR) ───────────────────────────────────────
  Future<void> _onRealtimeNotification(
    RealtimeNotificationReceivedEvent event,
    Emitter<NotificationState> emit,
  ) async {
    _notifications.insert(0, event.notification);
    _unreadCount++;

    emit(NotificationsLoaded(
      notifications: List.from(_notifications),
      hasNextPage: _hasNextPage,
      unreadCount: _unreadCount,
      activeCategory: _activeCategory,
    ));
  }
}