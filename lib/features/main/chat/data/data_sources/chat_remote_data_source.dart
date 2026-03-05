import 'package:sports_in/features/main/chat/data/models/chat_model_import.dart';

abstract class ChatRemoteDataSource {
  /// ✅ GET /api/Chat/list
  Future<PaginatedChatsResponse> getAllChats({
    int pageNumber = 1,
    int pageSize = 10,
  });

  /// ✅ GET /api/Chat/contacts
  Future<PaginatedContactsResponse> getContacts();

  /// ✅ GET /api/Chat/search
  /// Note: Query parameters should include searchTerm for filtering chats by name or participants, along with pagination parameters.
  Future<PaginatedSearchResponse> chatSearch({
    required String searchTerm,
    int pageNumber = 1,
    int pageSize = 10,
  });

  /// ✅ POST /api/Chat/send
  /// Note: Request body should include content, and either receiverId for private messages or groupId for group messages, along with optional attachmentFile.
  Future<MessageModel> sendMessage({
    required String content,
    String? receiverId,
    String? groupId,
    String? attachmentFile,
  });

  /// ✅ GET /api/chat/history/
  /// Note: Query parameters should include either targetUserId for private chats or groupId for group chats, along with pagination parameters.
  Future<PaginatedMessagesResponse> getChatHistory({
    String? targetUserId,
    String? groupId,
    int page = 1,
  });

  /// ✅ POST /api/Chat/group/create
  /// Note: Request body should include title, memberIds, and optionally description and groupPhoto.
  Future<ChatModel> createGroup({
    required String title,
    required List<String> memberIds,
    String? description,
    String? groupPhoto,
  });

  /// ✅ PUT /api/Chat/message/edit/{id}
  /// Note: Request body should include newContent and Path parameter should include the ID of the message to be edited.
  Future<MessageModel> editMessage({
    required String messageId,
    required String newContent,
  });

  /// ✅ DELETE /api/Chat/message/delete/{id}
  /// Note: Path parameter should include the ID of the message to be deleted.
  Future<void> deleteMessage({required String messageId});
}
