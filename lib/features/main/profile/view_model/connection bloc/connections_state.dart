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
  final List<UserContactItem> contacts;
  final List<ConnectionRequest> requests;

  final bool hasMoreRequests;
  final bool isLoadingMoreRequests;
  final int currentRequestPage;

  final bool hasMoreContacts;
  final bool isLoadingMoreContacts;
  final int currentContactPage;

  const ConnectionsLoaded({
    required this.contacts,
    required this.requests,
    this.hasMoreRequests = false,
    this.isLoadingMoreRequests = false,
    this.currentRequestPage = 1,
    this.hasMoreContacts = false,
    this.isLoadingMoreContacts = false,
    this.currentContactPage = 1,
  });

  ConnectionsLoaded copyWith({
    List<UserContactItem>? contacts,
    List<ConnectionRequest>? requests,
    bool? hasMoreRequests,
    bool? isLoadingMoreRequests,
    int? currentRequestPage,
    bool? hasMoreContacts,
    bool? isLoadingMoreContacts,
    int? currentContactPage,
  }) {
    return ConnectionsLoaded(
      contacts: contacts ?? this.contacts,
      requests: requests ?? this.requests,
      hasMoreRequests: hasMoreRequests ?? this.hasMoreRequests,
      isLoadingMoreRequests:
          isLoadingMoreRequests ?? this.isLoadingMoreRequests,
      currentRequestPage: currentRequestPage ?? this.currentRequestPage,
      hasMoreContacts: hasMoreContacts ?? this.hasMoreContacts,
      isLoadingMoreContacts:
          isLoadingMoreContacts ?? this.isLoadingMoreContacts,
      currentContactPage: currentContactPage ?? this.currentContactPage,
    );
  }

  @override
  List<Object?> get props => [
        contacts,
        requests,
        hasMoreRequests,
        isLoadingMoreRequests,
        currentRequestPage,
        hasMoreContacts,
        isLoadingMoreContacts,
        currentContactPage,
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