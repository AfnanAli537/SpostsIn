import 'package:injectable/injectable.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/network/endpoints.dart';
import 'package:sports_in/features/main/chat_bot/data/interface/chatbot_interface.dart';
import 'package:sports_in/features/main/chat_bot/data/models/chatbot_models.dart';


@LazySingleton(as: ChatbotRemoteDataSource)
class ChatbotRemoteDataSourceImpl implements ChatbotRemoteDataSource {
  final ApiClient _apiClient;

  ChatbotRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  ///✅ ─── Ask ───────────────────────────────────────────────────────────────
  @override
  Future<AskResponse> ask({
    required String question,
    required String sessionId,
  }) async {
    final response = await _apiClient.post(
      Endpoints.chatbotAsk,
      data: AskRequest(question: question, sessionId: sessionId).toJson(),
    );

    return AskResponse.fromJson(response.data as Map<String, dynamic>);
  }

  ///✅ ─── Get Sessions ───────────────────────────────────────────────────────
  @override
  Future<List<ChatSession>> getSessions() async {
    final response = await _apiClient.get(Endpoints.chatbotGetSessions);

    final list = response.data as List<dynamic>;
    return list
        .map((e) => ChatSession.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  ///✅ ─── Get Messages ───────────────────────────────────────────────────────
  @override
  Future<List<ChatMessage>> getMessages({required String sessionId}) async {
    final url = Endpoints.chatbotGetMessages.replaceFirst(
      '{sessionId}',
      sessionId,
    );
    final response = await _apiClient.get(url);

    final list = response.data as List<dynamic>;
    return list
        .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  ///✅ ─── Delete Session ─────────────────────────────────────────────────────
  @override
  Future<void> deleteSession({required String sessionId}) async {
    final url = Endpoints.chatbotDeleteSession.replaceFirst(
      '{sessionId}',
      sessionId,
    );
    await _apiClient.delete(url);
  }

  ///✅ ─── Rename Session ─────────────────────────────────────────────────────
  @override
  Future<void> renameSession({
    required String sessionId,
    required String newName,
  }) async {
    final url = Endpoints.chatbotRenameSession.replaceFirst(
      '{sessionId}',
      sessionId,
    );
    await _apiClient.put(url, data: {'newName': newName});
  }
}