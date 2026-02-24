
import 'package:sports_in/features/main/chat/data/models/chat_models.dart';

abstract class ChatInterface {
  /// GET /api/Chat/list
  Future<PaginatedChatsResponse> getAllChats({
    int pageNumber = 1,
    int pageSize = 10,
  });

  /// GET /api/Chat/contacts
  Future<PaginatedContactsResponse> getContacts(
  );

  /// GET /api/Chat/search
  Future<PaginatedChatsResponse> chatSearch({
    required String searchTerm,
    int pageNumber = 1,
    int pageSize = 10,
  });

  /// POST /api/Chat/send
Future<MessageModel> sendMessage({
  required String content,   
  String? receiverId,      
  String? groupId,          
  String? attachmentFile,    
});

  /// GET /api/Chat/history
  Future<PaginatedMessagesResponse> getAllMessages({
    String? targetUserId,
    String? groupId,
    int page = 1,
  });

  /// POST /api/Chat/group/create
  Future<ChatModel> createGroup({
    required String title,
    required List<String> memberIds,
    String? description,
    String? groupPhoto,
  });

  /// PUT /api/Chat/message/edit/{id}
  Future<MessageModel> editMessage({
    required String messageId,
    required String newContent,
  });

  /// DELETE /api/Chat/message/delete/{id}
  Future<void> deleteMessage({required String messageId});
}