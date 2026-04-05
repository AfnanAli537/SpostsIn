// connections_state.dart
import 'package:equatable/equatable.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';

abstract class ConnectionsState extends Equatable {
  const ConnectionsState();
  @override
  List<Object?> get props => [];
}

class ConnectionsInitial extends ConnectionsState {}

class ConnectionsLoading extends ConnectionsState {}

class ConnectionsLoaded extends ConnectionsState {
  final List<ContactItem> contacts;
  final List<ConnectionRequest> requests;
  final bool hasMoreRequests;
  final bool isLoadingMoreRequests;
  final int currentRequestPage;

  const ConnectionsLoaded({
    required this.contacts,
    required this.requests,
    this.hasMoreRequests = false,
    this.isLoadingMoreRequests = false,
    this.currentRequestPage = 1,
  });

  ConnectionsLoaded copyWith({
    List<ContactItem>? contacts,
    List<ConnectionRequest>? requests,
    bool? hasMoreRequests,
    bool? isLoadingMoreRequests,
    int? currentRequestPage,
  }) {
    return ConnectionsLoaded(
      contacts: contacts ?? this.contacts,
      requests: requests ?? this.requests,
      hasMoreRequests: hasMoreRequests ?? this.hasMoreRequests,
      isLoadingMoreRequests: isLoadingMoreRequests ?? this.isLoadingMoreRequests,
      currentRequestPage: currentRequestPage ?? this.currentRequestPage,
    );
  }

  @override
  List<Object?> get props => [
        contacts,
        requests,
        hasMoreRequests,
        isLoadingMoreRequests,
        currentRequestPage,
      ];
}

class ConnectionsError extends ConnectionsState {
  final String message;
  const ConnectionsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ConnectionsActionError extends ConnectionsState {
  final String message;
  const ConnectionsActionError({required this.message});

  @override
  List<Object?> get props => [message];
}