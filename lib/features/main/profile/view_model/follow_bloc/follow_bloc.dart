// followers_bloc.dart
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
// import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/features/main/profile/data/repo/profile_repo.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
part 'follow_event.dart';
part 'follow_state.dart';

@injectable
class FollowListBloc extends Bloc<FollowListEvent, FollowListState> {
  final ProfileRepo _repository;
  // final SharedPref _sharedPref;
  String? _userId;
  FollowListType? _type;
  int _page = 1;
  bool _hasNext = true;
  bool _isFetching = false;
  final List<UserContactItem> _items = [];

  FollowListBloc(
    this._repository,
    //  this._sharedPref
  ) : super(FollowListInitial()) {
    on<LoadFollowList>(_onLoad);
    on<LoadMoreFollowList>(_onLoadMore);
    on<ToggleFollowOnItem>(_onToggleFollow);
    on<SendConnectionRequestOnItem>(_onSendConnectionRequest);
    on<RemoveContactOnItem>(_onRemoveContact);
    on<AcceptConnectionRequestOnItem>(_onAcceptConnection);
    on<RejectConnectionRequestOnItem>(_onRejectConnection);
  }

  // String get _currentUserId {
  //   final id = _sharedPref.getUserId();
  //   if (id == null) throw Exception('User not logged in');
  //   return id;
  // }

  Future<void> _onLoad(
    LoadFollowList event,
    Emitter<FollowListState> emit,
  ) async {
    try {
      emit(FollowListLoading());
      _userId = event.userId;
      _type = event.type;
      _page = 1;
      _hasNext = true;
      _items.clear();

      final result = event.type == FollowListType.followers
          ? await _repository.getFollowers(
              userId: event.userId,
              pageNumber: 1,
              pageSize: 20,
            )
          : await _repository.getFollowing(
              userId: event.userId,
              pageNumber: 1,
              pageSize: 20,
            );

      _items.addAll(result.items);
      _hasNext = result.hasNextPage;
      emit(
        FollowListLoaded(
          items: List.from(_items),
          hasNextPage: _hasNext,
          currentPage: 1,
          type: event.type,
        ),
      );
    } catch (e) {
      emit(FollowListError(e is ApiException ? e.message : e.toString()));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreFollowList event,
    Emitter<FollowListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FollowListLoaded) return;
    if (!_hasNext || _isFetching) return;
    _isFetching = true;

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final nextPage = _page + 1;
      final result = _type == FollowListType.followers
          ? await _repository.getFollowers(
              userId: _userId!,
              pageNumber: nextPage,
              pageSize: 20,
            )
          : await _repository.getFollowing(
              userId: _userId!,
              pageNumber: nextPage,
              pageSize: 20,
            );

      _items.addAll(result.items);
      _page = nextPage;
      _hasNext = result.hasNextPage;
      emit(
        FollowListLoaded(
          items: List.from(_items),
          hasNextPage: _hasNext,
          currentPage: _page,
          isLoadingMore: false,
          type: _type!,
        ),
      );
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
      emit(FollowListError('Failed to load more'));
    } finally {
      _isFetching = false;
    }
  }

  // Follow/Unfollow
  Future<void> _onToggleFollow(
    ToggleFollowOnItem event,
    Emitter<FollowListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FollowListLoaded) return;

    final updatedItems = currentState.items.map((item) {
      if (item.userId == event.targetUserId) {
        return item.copyWith(isFollowedByMe: !item.isFollowedByMe);
      }
      return item;
    }).toList();

    emit(currentState.copyWith(items: updatedItems));

    try {
      await _repository.toggleFollow(event.targetUserId);
    } catch (e) {
      emit(currentState.copyWith(items: currentState.items));
      emit(FollowListError('Failed to update follow status'));
    }
  }

  // Send connection request (Connect button when status == null)
  Future<void> _onSendConnectionRequest(
    SendConnectionRequestOnItem event,
    Emitter<FollowListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FollowListLoaded) return;

    final updatedItems = currentState.items.map((item) {
      if (item.userId == event.receiverId) {
        return item.copyWith(connectionStatus: 'Pending_Sent');
      }
      return item;
    }).toList();

    emit(currentState.copyWith(items: updatedItems));

    try {
      await _repository.sendConnectionRequest(event.receiverId);
    } catch (e) {
      emit(currentState.copyWith(items: currentState.items));
      emit(FollowListError('Failed to send request'));
    }
  }

  // Remove contact (when connectionStatus == 'Accepted')
  Future<void> _onRemoveContact(
    RemoveContactOnItem event,
    Emitter<FollowListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FollowListLoaded) return;

    final updatedItems = currentState.items.map((item) {
      if (item.userId == event.targetId) {
        return item.copyWith(connectionStatus: null);
      }
      return item;
    }).toList();

    emit(currentState.copyWith(items: updatedItems));

    try {
      await _repository.removeContact(event.targetId);
    } catch (e) {
      emit(currentState.copyWith(items: currentState.items));
      emit(FollowListError('Failed to remove contact'));
    }
  }

  // Accept connection (incoming request)
  Future<void> _onAcceptConnection(
    AcceptConnectionRequestOnItem event,
    Emitter<FollowListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FollowListLoaded) return;

    // Optimistically change status to 'Accepted' → button becomes "Remove Contact"
    final updatedItems = currentState.items.map((item) {
      if (item.userId == event.senderId) {
        return item.copyWith(connectionStatus: 'Accepted');
      }
      return item;
    }).toList();
    emit(currentState.copyWith(items: updatedItems));

    try {
      await _repository.respondConnection(
        senderId: event.senderId,
        status: 'Accepted',
      );
    } catch (e) {
      // Rollback on error
      emit(currentState.copyWith(items: currentState.items));
      emit(FollowListError('Failed to accept request'));
    }
  }

  // In FollowListBloc
  Future<void> _onRejectConnection(
    RejectConnectionRequestOnItem event,
    Emitter<FollowListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FollowListLoaded) return;

    // Optimistically set connectionStatus to null
    final updatedItems = currentState.items.map((item) {
        log('Comparing item.userId: ${item.userId} with event.senderId: ${event.senderId}');
      if (item.userId == event.senderId) {
        log('✅ Match found for ${item.userId}, setting status to null');
        return item.copyWith(connectionStatus: null); // ✅ change to null
      }
      return item;
    }).toList();

    // Emit the new state with updated list
    emit(currentState.copyWith(items: updatedItems));

    try {
      await _repository.respondConnection(
        senderId: event.senderId,
        status: 'Rejected',
      );
      print('Reject: updated items count = ${updatedItems.length}, first status = ${updatedItems.first.connectionStatus}');
    } catch (e) {
      // Rollback on error – revert to original list
      emit(currentState.copyWith(items: currentState.items));
      emit(FollowListError('Failed to reject request'));
      // Re‑emit the loaded state to keep the list consistent
      emit(currentState.copyWith(items: currentState.items));
    }
  }
}
