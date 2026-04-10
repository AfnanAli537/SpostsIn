
import 'package:sports_in/features/main/chat_bot/data/models/chatbot_models.dart';

abstract class ChatbotRemoteDataSource {
  /// ✅ POST /api/Chatbot/ask
  /// Pass empty [sessionId] to start a new session.
  Future<AskResponse> ask({
    required String question,
    required String sessionId,
  });

  /// ✅ GET /api/Chatbot/get-sessions
  Future<List<ChatSession>> getSessions();

  /// ✅ GET /api/Chatbot/get-messages/{sessionId}
  Future<List<ChatMessage>> getMessages({required String sessionId});

  /// ✅ DELETE /api/Chatbot/delete-session/{sessionId}
  Future<void> deleteSession({required String sessionId});

  /// ✅ PUT /api/Chatbot/rename-session/{sessionId}
  Future<void> renameSession({
    required String sessionId,
    required String newName,
  });
}