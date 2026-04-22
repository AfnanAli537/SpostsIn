// connections_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/features/main/profile/data/repo/profile_repo.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
import 'connections_event.dart';
import 'connections_state.dart';

const int _kPageSize = 20;

@injectable
class ConnectionsBloc extends Bloc<ConnectionsEvent, ConnectionsState> {
  final ProfileRepo _repository;
  final SharedPref _sharedPref;

  // ignore: unused_field
  String? _viewingUserId;

  ConnectionsBloc(this._repository, this._sharedPref)
    : super(ConnectionsInitial()) {
    on<LoadConnections>(_onLoadConnections);
    on<LoadMoreContacts>(_onLoadMoreContacts);
    on<LoadMoreRequests>(_onLoadMoreRequests);
    on<RespondToRequest>(_onRespondToRequest);
    on<ToggleFollowContact>(_onToggleFollowContact);
    on<RemoveContact>(_onRemoveContact);
    on<SendConnectionRequestToContact>(_onSendConnectionRequest);
  }

  String get _currentUserId {
    final id = _sharedPref.getUserId();
    if (id == null) throw Exception('User not logged in');
    return id;
  }

  // ── Initial load (fixed null userId) ─────────────────────────────────────
  Future<void> _onLoadConnections(
    LoadConnections event,
    Emitter<ConnectionsState> emit,
  ) async {
    try {
      emit(ConnectionsLoading());
      _viewingUserId = event.userId;

      final effectiveUserId = event.userId ?? _currentUserId;

      if (event.userId != null) {
        // Other user – only contacts
        final result = await _repository.getUserConnections(
          userId: effectiveUserId,
          pageNumber: 1,
          pageSize: _kPageSize,
        );
        emit(
          ConnectionsLoaded(
            contacts: result.items,
            requests: const [],
            hasMoreContacts: result.hasNextPage,
            currentContactPage: 1,
          ),
        );
      } else {
        // Owner – contacts + requests
        final contacts = await _repository.getUserConnections(
          userId: effectiveUserId,
          pageNumber: 1,
          pageSize: _kPageSize,
        );
        final requestResult = await _repository.getConnectionRequests(
          pageNumber: 1,
          pageSize: _kPageSize,
        );
        emit(
          ConnectionsLoaded(
            contacts: contacts.items,
            requests: requestResult.items,
            hasMoreRequests: requestResult.hasNextPage,
            currentRequestPage: 1,
          ),
        );
      }
    } catch (e) {
      emit(
        ConnectionsError(message: e is ApiException ? e.message : e.toString()),
      );
    }
  }

  // ── Load more contacts (unchanged) ──────────────────────────────────────
  Future<void> _onLoadMoreContacts(
    LoadMoreContacts event,
    Emitter<ConnectionsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ConnectionsLoaded) return;
    if (!currentState.hasMoreContacts || currentState.isLoadingMoreContacts)
      return;

    if (_viewingUserId == null) return;

    emit(currentState.copyWith(isLoadingMoreContacts: true));

    try {
      final nextPage = currentState.currentContactPage + 1;
      final result = await _repository.getUserConnections(
        userId: _viewingUserId!,
        pageNumber: nextPage,
        pageSize: _kPageSize,
      );

      final latestState = state;
      if (latestState is! ConnectionsLoaded) return;

      emit(
        latestState.copyWith(
          contacts: [...latestState.contacts, ...result.items],
          hasMoreContacts: result.hasNextPage,
          isLoadingMoreContacts: false,
          currentContactPage: nextPage,
        ),
      );
    } catch (e) {
      final latestState = state;
      if (latestState is ConnectionsLoaded) {
        emit(latestState.copyWith(isLoadingMoreContacts: false));
      }
      emit(
        ConnectionsActionError(
          message: 'Failed to load more contacts. Please try again.',
        ),
      );
    }
  }

  // ── Load more requests (unchanged) ──────────────────────────────────────
  Future<void> _onLoadMoreRequests(
    LoadMoreRequests event,
    Emitter<ConnectionsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ConnectionsLoaded) return;
    if (!currentState.hasMoreRequests || currentState.isLoadingMoreRequests) {
      return;
    }

    emit(currentState.copyWith(isLoadingMoreRequests: true));

    try {
      final nextPage = currentState.currentRequestPage + 1;
      final result = await _repository.getConnectionRequests(
        pageNumber: nextPage,
        pageSize: _kPageSize,
      );

      final latestState = state;
      if (latestState is! ConnectionsLoaded) return;

      emit(
        latestState.copyWith(
          requests: [...latestState.requests, ...result.items],
          hasMoreRequests: result.hasNextPage,
          isLoadingMoreRequests: false,
          currentRequestPage: nextPage,
        ),
      );
    } catch (e) {
      final latestState = state;
      if (latestState is ConnectionsLoaded) {
        emit(latestState.copyWith(isLoadingMoreRequests: false));
      }
      emit(
        ConnectionsActionError(
          message: 'Failed to load more requests. Please try again.',
        ),
      );
      if (state is! ConnectionsLoaded) {
        emit(currentState.copyWith(isLoadingMoreRequests: false));
      }
    }
  }

  // ── Respond to request (FIXED: refresh contacts with correct userId) ────
  Future<void> _onRespondToRequest(
    RespondToRequest event,
    Emitter<ConnectionsState> emit,
  ) async {
    final currentState = state;
    if (currentState is ConnectionsLoaded) {
      // Optimistically remove request
      final updatedRequests = currentState.requests
          .where((r) => r.id != event.senderId)
          .toList();
      emit(currentState.copyWith(requests: updatedRequests));

      try {
        await _repository.respondConnection(
          senderId: event.senderId,
          status: event.status,
        );

        if (event.status == 'Accepted') {
          // Refresh contacts using the correct user ID
          final userIdToRefresh = event.userId ?? _currentUserId;
          final contactsResult = await _repository.getUserConnections(
            userId: userIdToRefresh,
            pageNumber: 1,
            pageSize: _kPageSize,
          );

          final latestState = state;
          if (latestState is ConnectionsLoaded) {
            emit(
              latestState.copyWith(
                contacts: contactsResult.items,
                hasMoreContacts: contactsResult.hasNextPage,
                currentContactPage: 1,
              ),
            );
          }
        }
      } catch (e) {
        // Rollback on error
        emit(currentState);
        emit(
          ConnectionsActionError(
            message: 'Failed to respond to request. Please try again.',
          ),
        );
        emit(currentState.copyWith(requests: updatedRequests));
      }
      return;
    }

    // Fallback if state is not loaded
    try {
      await _repository.respondConnection(
        senderId: event.senderId,
        status: event.status,
      );
    } catch (e) {
      emit(
        ConnectionsActionError(
          message: 'Failed to respond to request. Please try again.',
        ),
      );
    }
  }

  // ── Follow / Unfollow a contact ─────────────────────────────────────────
  Future<void> _onToggleFollowContact(
    ToggleFollowContact event,
    Emitter<ConnectionsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ConnectionsLoaded) return;

    // Optimistically toggle the follow status
    final updatedContacts = currentState.contacts.map((contact) {
      if (contact.userId == event.contactUserId) {
        return UserContactItem(
          userId: contact.userId,
          fullName: contact.fullName,
          profilePictureUrl: contact.profilePictureUrl,
          userType: contact.userType,
          bio: contact.bio,
          isFollowedByMe: !contact.isFollowedByMe,
          connectionStatus: contact.connectionStatus,
        );
      }
      return contact;
    }).toList();

    emit(currentState.copyWith(contacts: updatedContacts));

    try {
      await _repository.toggleFollow(event.contactUserId);
    } catch (e) {
      // Rollback on error
      emit(currentState);
      emit(ConnectionsActionError(message: 'Failed to update follow status.'));
      emit(currentState.copyWith(contacts: updatedContacts));
    }
  }

  // ── Remove a contact (only when connectionStatus == 'Accepted') ─────────
  Future<void> _onRemoveContact(
    RemoveContact event,
    Emitter<ConnectionsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ConnectionsLoaded) return;

    // Optimistically remove the contact from the list
    final updatedContacts = currentState.contacts
        .where((c) => c.userId != event.contactUserId)
        .toList();

    emit(currentState.copyWith(contacts: updatedContacts));

    try {
      await _repository.removeContact(event.contactUserId);
    } catch (e) {
      // Rollback on error
      emit(currentState);
      emit(ConnectionsActionError(message: 'Failed to remove contact.'));
      emit(currentState.copyWith(contacts: updatedContacts));
    }
  }

  // ── Send a connection request ───────────────────────────────────────────
  Future<void> _onSendConnectionRequest(
    SendConnectionRequestToContact event,
    Emitter<ConnectionsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ConnectionsLoaded) return;

    // Find the contact and update its status to 'Pending' optimistically
    final updatedContacts = currentState.contacts.map((contact) {
      if (contact.userId == event.receiverId) {
        return UserContactItem(
          userId: contact.userId,
          fullName: contact.fullName,
          profilePictureUrl: contact.profilePictureUrl,
          userType: contact.userType,
          bio: contact.bio,
          isFollowedByMe: contact.isFollowedByMe,
          connectionStatus: 'Pending',
        );
      }
      return contact;
    }).toList();

    emit(currentState.copyWith(contacts: updatedContacts));

    try {
      await _repository.sendConnectionRequest(event.receiverId);
    } catch (e) {
      // Rollback on error
      emit(currentState);
      emit(
        ConnectionsActionError(message: 'Failed to send connection request.'),
      );
      emit(currentState.copyWith(contacts: updatedContacts));
    }
  }
}
