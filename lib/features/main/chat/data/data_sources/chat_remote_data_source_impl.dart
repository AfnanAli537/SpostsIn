import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/network/endpoints.dart';
import 'package:sports_in/features/main/chat/data/data_sources/chat_remote_data_source.dart';
import 'package:sports_in/features/main/chat/data/models/chat_model_import.dart';

@LazySingleton(as: ChatRemoteDataSource)
class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiClient _apiClient;

  ChatRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  ///✅ ─── Get All Chats ───────────────────────────────────────────────────────────

  @override
  Future<PaginatedChatsResponse> getAllChats({
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    final response = await _apiClient.get(
      Endpoints.getAllChats,
      params: {'pageNumber': pageNumber, 'pageSize': pageSize},
    );

    // API returns a paginated object:
    // { items: [...], totalCount: ..., pageNumber: ..., ... }
    return PaginatedChatsResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  ///✅ ─── Get Contacts ─────────────────────────────────────────────────────────────

  @override
  Future<PaginatedContactsResponse> getContacts() async {
    final response = await _apiClient.get(Endpoints.getContacts);

    return PaginatedContactsResponse.fromJson(response.data);
  }

  ///✅ ─── Search Chats ─────────────────────────────────────────────────────────────

  @override
  Future<PaginatedSearchResponse> chatSearch({
    required String searchTerm,
    int pageNumber = 1,
    int pageSize = 10,
  }) async {
    final response = await _apiClient.get(
      Endpoints.chatSearch,
      params: {
        'query': searchTerm,
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );

    return PaginatedSearchResponse.fromJson(response.data);
  }

  ///✅ ─── Send Message ─────────────────────────────────────────────────────────────

  @override
  Future<MessageModel> sendMessage({
    required String content,
    String? receiverId,
    String? groupId,
    String? attachmentFile,
  }) async {
    final formData = FormData.fromMap({
      'Content': content,
      if (receiverId != null) 'ReceiverId': receiverId,
      if (groupId != null) 'GroupId': groupId,
      if (attachmentFile != null)
        'Attachment': await MultipartFile.fromFile(attachmentFile),
    });

    final response = await _apiClient.post(
      Endpoints.sendMessage,
      data: formData,
    );

    return MessageModel.fromJson(response.data);
  }

  ///✅ ─── Get Chat History  ───────────────────────────────────────────────────────────

  @override
  Future<PaginatedMessagesResponse> getChatHistory({
    String? targetUserId,
    String? groupId,
    int page = 1,
  }) async {
    final response = await _apiClient.get(
      Endpoints.getAllMessages,
      params: {
        if (targetUserId != null) 'targetUserId': targetUserId,
        if (groupId != null) 'groupId': groupId,
        'page': page,
      },
    );

    // API returns a paginated object similar to chats:
    // { items: [...], totalCount: ..., pageNumber: ..., ... }
    return PaginatedMessagesResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  ///✅ ─── Create Group ─────────────────────────────────────────────────────────────
  // API body: Title* (string), Description (string), GroupPhoto (binary), MemberIds* (array<string>)

  @override
  Future<ChatModel> createGroup({
    required String title,
    required List<String> memberIds,
    String? description,
    String? groupPhoto,
  }) async {
    final formData = FormData.fromMap({
      'Title': title,
      'MemberIds': memberIds,
      if (description != null) 'Description': description,
      if (groupPhoto != null)
        'GroupPhoto': await MultipartFile.fromFile(groupPhoto),
    });

    final response = await _apiClient.post(
      Endpoints.createGroup,
      data: formData,
    );

    return ChatModel.fromJson(response.data);
  }

  ///✅ ─── Edit Message ─────────────────────────────────────────────────────────────

  @override
  Future<MessageModel> editMessage({
    required String messageId,
    required String newContent,
  }) async {
    final url = Endpoints.editMessage.replaceFirst('{id}', messageId);

    final response = await _apiClient.put(
      url,
      data: {'newContent': newContent},
    );

    return MessageModel.fromJson(response.data);
  }

  ///✅ ─── Delete Message ───────────────────────────────────────────────────────────

  @override
  Future<void> deleteMessage({required String messageId}) async {
    final url = Endpoints.deleteMessage.replaceFirst('{id}', messageId);
    await _apiClient.delete(url);
  }
}
