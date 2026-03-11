// connections_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/features/main/profile/data/repo/profile_repo.dart';
import 'connections_event.dart';
import 'connections_state.dart';

@injectable
class ConnectionsBloc extends Bloc<ConnectionsEvent, ConnectionsState> {
  final ProfileRepo _repository;

  ConnectionsBloc(this._repository) : super(ConnectionsInitial()) {
    on<LoadConnections>(_onLoadConnections);
    on<RespondToRequest>(_onRespondToRequest);
  }

  Future<void> _onLoadConnections(
    LoadConnections event,
    Emitter<ConnectionsState> emit,
  ) async {
    try {
      emit(ConnectionsLoading());
      final results = await Future.wait([
        _repository.getContacts(),
        _repository.getConnectionRequests(),
      ]);
      emit(ConnectionsLoaded(
        contacts: results[0] as dynamic,
        requests: results[1] as dynamic,
      ));
    } catch (e) {
      emit(ConnectionsError(
          message: e is ApiException ? e.message : e.toString()));
    }
  }

  Future<void> _onRespondToRequest(
    RespondToRequest event,
    Emitter<ConnectionsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ConnectionsLoaded) return;

    // Optimistic removal of the request from the list
    final updatedRequests = currentState.requests
        .where((r) => r.id != event.senderId)
        .toList();

    emit(currentState.copyWith(requests: updatedRequests));

    try {
      await _repository.respondConnection(
        senderId: event.senderId,
        status: event.status,
      );

      // If accepted, reload contacts to include the newly accepted person
      if (event.status == 'Accepted') {
        final contacts = await _repository.getContacts();
        final latestState = state;
        if (latestState is ConnectionsLoaded) {
          emit(latestState.copyWith(contacts: contacts));
        }
      }
    } catch (e) {
      // Revert on failure
      emit(currentState);
      emit(ConnectionsActionError(
          message: 'Failed to respond to request. Please try again.'));
      // Re-emit the optimistically updated state so the UI stays consistent
      emit(currentState.copyWith(requests: updatedRequests));
    }
  }
}