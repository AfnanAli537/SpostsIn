// connections_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/features/main/profile/data/repo/profile_repo.dart';
import 'connections_event.dart';
import 'connections_state.dart';

const int _kPageSize = 20;

@injectable
class ConnectionsBloc extends Bloc<ConnectionsEvent, ConnectionsState> {
  final ProfileRepo _repository;

  ConnectionsBloc(this._repository) : super(ConnectionsInitial()) {
    on<LoadConnections>(_onLoadConnections);
    on<LoadMoreRequests>(_onLoadMoreRequests);
    on<RespondToRequest>(_onRespondToRequest);
  }

  // ── Initial load ──────────────────────────────────────────────────────────────

  Future<void> _onLoadConnections(
    LoadConnections event,
    Emitter<ConnectionsState> emit,
  ) async {
    try {
      emit(ConnectionsLoading());

      if (event.userId != null) {
        // Viewing another user's profile — contacts only, no requests
        final contacts = await _repository.getContacts(userId: event.userId);
        emit(ConnectionsLoaded(
          contacts: contacts,
          requests: const [],
          hasMoreRequests: false,
          currentRequestPage: 1,
        ));
      } else {
        // Owner viewing their own screen — contacts + paginated requests
        final contacts = await _repository.getContacts();
        final requestResult = await _repository.getConnectionRequests(
          pageNumber: 1,
          pageSize: _kPageSize,
        );
        emit(ConnectionsLoaded(
          contacts: contacts,
          requests: requestResult.items,
          hasMoreRequests: requestResult.hasNextPage,
          currentRequestPage: 1,
        ));
      }
    } catch (e) {
      emit(ConnectionsError(
          message: e is ApiException ? e.message : e.toString()));
    }
  }

  // ── Load next page of requests (owner only) ───────────────────────────────────

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

      emit(latestState.copyWith(
        requests: [...latestState.requests, ...result.items],
        hasMoreRequests: result.hasNextPage,
        isLoadingMoreRequests: false,
        currentRequestPage: nextPage,
      ));
    } catch (e) {
      final latestState = state;
      if (latestState is ConnectionsLoaded) {
        emit(latestState.copyWith(isLoadingMoreRequests: false));
      }
      emit(ConnectionsActionError(
          message: 'Failed to load more requests. Please try again.'));
      if (state is! ConnectionsLoaded) {
        emit(currentState.copyWith(isLoadingMoreRequests: false));
      }
    }
  }

  // ── Respond to a single request ───────────────────────────────────────────────
  // NOTE: No ConnectionsLoaded guard — works standalone (e.g. from NotificationScreen)

  Future<void> _onRespondToRequest(
    RespondToRequest event,
    Emitter<ConnectionsState> emit,
  ) async {
    final currentState = state;

    // If we have a loaded state, do the full optimistic update flow
    if (currentState is ConnectionsLoaded) {
      final updatedRequests =
          currentState.requests.where((r) => r.id != event.senderId).toList();
      emit(currentState.copyWith(requests: updatedRequests));

      try {
        await _repository.respondConnection(
          senderId: event.senderId,
          status: event.status,
        );
        if (event.status == 'Accepted') {
          final contacts = await _repository.getContacts();
          final latestState = state;
          if (latestState is ConnectionsLoaded) {
            emit(latestState.copyWith(contacts: contacts));
          }
        }
      } catch (e) {
        emit(currentState);
        emit(ConnectionsActionError(
            message: 'Failed to respond to request. Please try again.'));
        emit(currentState.copyWith(requests: updatedRequests));
      }
      return;
    }

    // Standalone mode (e.g. NotificationScreen) — just call the API, no state to update
    try {
      await _repository.respondConnection(
        senderId: event.senderId,
        status: event.status,
      );
    } catch (e) {
      emit(ConnectionsActionError(
          message: 'Failed to respond to request. Please try again.'));
      // Restore previous state so the snackbar listener fires then clears
      emit(currentState);
    }
  }
}