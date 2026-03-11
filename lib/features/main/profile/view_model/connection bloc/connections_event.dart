// connections_event.dart
import 'package:equatable/equatable.dart';

abstract class ConnectionsEvent extends Equatable {
  const ConnectionsEvent();
  @override
  List<Object?> get props => [];
}

class LoadConnections extends ConnectionsEvent {}

class RespondToRequest extends ConnectionsEvent {
  final String senderId;
  final String status; // "Accepted" or "Rejected"

  const RespondToRequest({required this.senderId, required this.status});

  @override
  List<Object?> get props => [senderId, status];
}