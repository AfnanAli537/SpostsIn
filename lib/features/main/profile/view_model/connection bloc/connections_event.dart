// connections_event.dart
import 'package:equatable/equatable.dart';

abstract class ConnectionsEvent extends Equatable {
  const ConnectionsEvent();
  @override
  List<Object?> get props => [];
}

class LoadConnections extends ConnectionsEvent {
  final String? userId;

  const LoadConnections({this.userId});

  @override
  List<Object?> get props => [userId];
}

class LoadMoreContacts extends ConnectionsEvent {}

class LoadMoreRequests extends ConnectionsEvent {}

class RespondToRequest extends ConnectionsEvent {
  final String? userId;
  final String senderId;
  final String status; 

  const RespondToRequest({required this.senderId, required this.status, this.userId});

  @override
  List<Object?> get props => [senderId, status, userId];
}
class ToggleFollowContact extends ConnectionsEvent {
  final String contactUserId;
  const ToggleFollowContact(this.contactUserId);
}

class RemoveContact extends ConnectionsEvent {
  final String contactUserId;
  const RemoveContact(this.contactUserId);
}

class SendConnectionRequestToContact extends ConnectionsEvent {
  final String receiverId;
  const SendConnectionRequestToContact(this.receiverId);
}