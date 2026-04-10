part of 'chatbot_bloc.dart';

sealed class ChatbotEvent extends Equatable {
  const ChatbotEvent();

  @override
  List<Object> get props => [];
}


// ─── Sessions ─────────────────────────────────────────────────────────────────
class LoadSessionsEvent extends ChatbotEvent {}

class DeleteSessionEvent extends ChatbotEvent {
  final String sessionId;
  const DeleteSessionEvent({required this.sessionId});
}

class RenameSessionEvent extends ChatbotEvent {
  final String sessionId;
  final String newName;
  const RenameSessionEvent({required this.sessionId, required this.newName});
}

class SelectSessionEvent extends ChatbotEvent {
  final String sessionId;
  const SelectSessionEvent({required this.sessionId});
}

// ─── Messages ─────────────────────────────────────────────────────────────────
class LoadMessagesEvent extends ChatbotEvent {
  final String sessionId;
  const LoadMessagesEvent({required this.sessionId});
}

// ─── Ask ──────────────────────────────────────────────────────────────────────
class SendMessageEvent extends ChatbotEvent {
  final String question;
  /// Pass empty string to start a new session
  final String sessionId;
  const SendMessageEvent({required this.question, required this.sessionId});
}

// ─── UI ───────────────────────────────────────────────────────────────────────
class StartNewChatEvent extends ChatbotEvent {}