// ─── Ask Request ─────────────────────────────────────────────────────────────
class AskRequest {
  final String question;
  final String sessionId;

  const AskRequest({
    required this.question,
    required this.sessionId,
  });

  Map<String, dynamic> toJson() => {
        'question': question,
        'session_id': sessionId,
      };
}

// ─── Ask Response ─────────────────────────────────────────────────────────────
class AskResponse {
  final String status;
  final String sessionId;
  final String sessionName;
  final String answer;
  final String? message;

  const AskResponse({
    required this.status,
    required this.sessionId,
    required this.sessionName,
    required this.answer,
    this.message,
  });

  factory AskResponse.fromJson(Map<String, dynamic> json) {
    final answer = json['answer'] as Map<String, dynamic>;
    return AskResponse(
      status: answer['status'] as String,
      sessionId: answer['session_id'] as String,
      sessionName: answer['session_name'] as String,
      answer: answer['answer'] as String,
      message: answer['message'] as String?,
    );
  }
}

// ─── Session Model ────────────────────────────────────────────────────────────
class ChatSession {
  final String sessionId;
  final String sessionName;
  final DateTime createdAt;

  const ChatSession({
    required this.sessionId,
    required this.sessionName,
    required this.createdAt,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) => ChatSession(
        sessionId: json['sessionId'] as String,
        sessionName: json['sessionName'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

// ─── Chat Message Model ───────────────────────────────────────────────────────
class ChatMessage {
  final String role;
  final String content;
  final DateTime timestamp;

  const ChatMessage({
    required this.role,
    required this.content,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        role: json['role'] as String,
        content: json['content'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}