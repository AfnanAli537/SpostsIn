part of 'chatbot_bloc.dart';

sealed class ChatbotState extends Equatable {
  const ChatbotState();
  
  @override
  List<Object> get props => [];
}


// ─── Initial ──────────────────────────────────────────────────────────────────
class ChatbotInitial extends ChatbotState {}

// ─── Sessions ─────────────────────────────────────────────────────────────────
class SessionsLoading extends ChatbotState {}

class SessionsLoaded extends ChatbotState {
  final List<ChatSession> sessions;
  const SessionsLoaded({required this.sessions});
}

class SessionsError extends ChatbotState {
  final String message;
  const SessionsError({required this.message});
}

class SessionDeleted extends ChatbotState {
  final List<ChatSession> sessions;
  const SessionDeleted({required this.sessions});
}

class SessionRenamed extends ChatbotState {
  final List<ChatSession> sessions;
  const SessionRenamed({required this.sessions});
}

// ─── Messages ─────────────────────────────────────────────────────────────────
class MessagesLoading extends ChatbotState {}

class MessagesLoaded extends ChatbotState {
  final String sessionId;
  final List<ChatMessage> messages;
  const MessagesLoaded({required this.sessionId, required this.messages});
}

class MessagesError extends ChatbotState {
  final String message;
  const MessagesError({required this.message});
}

// ─── Ask ──────────────────────────────────────────────────────────────────────
class SendingMessage extends ChatbotState {
  final List<ChatMessage> messages;
  const SendingMessage({required this.messages});
}

class MessageSent extends ChatbotState {
  final String sessionId;
  final List<ChatMessage> messages;
  const MessageSent({required this.sessionId, required this.messages});
}

class SendMessageError extends ChatbotState {
  final String message;
  final List<ChatMessage> messages;
  const SendMessageError({required this.message, required this.messages});
}