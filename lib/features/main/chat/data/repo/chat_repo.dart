import 'package:injectable/injectable.dart';
import 'package:sports_in/features/main/chat/data/interfaces/chat_interface.dart';
import 'package:sports_in/features/main/chat/data/models/chat_models.dart';

@lazySingleton
class ChatRepository {
  final ChatInterface repo;

  ChatRepository(this.repo);

  // ─── Get All Chats ─────────────────────────────────────────────────────────

  Future<PaginatedChatsResponse> getAllChats({
    int pageNumber = 1,
    int pageSize = 10,
  }) {
    return repo.getAllChats(pageNumber: pageNumber, pageSize: pageSize);
  }

  // ─── Get Contacts ──────────────────────────────────────────────────────────

  Future<PaginatedContactsResponse> getContacts() {
    return repo.getContacts();
  }

  // ─── Search Chats ──────────────────────────────────────────────────────────

  Future<PaginatedChatsResponse> chatSearch({
    required String searchTerm,
    int pageNumber = 1,
    int pageSize = 10,
  }) {
    return repo.chatSearch(
      searchTerm: searchTerm,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }

  // ─── Send Message ──────────────────────────────────────────────────────────

 Future<MessageModel> sendMessage({
    required String content,
    String? receiverId,
    String? groupId,
    String? attachmentFile,
  }) {
    return repo.sendMessage(
      content: content,
      receiverId: receiverId,
      groupId: groupId,
      attachmentFile: attachmentFile,
    );
  }
  // ─── Get Message History ───────────────────────────────────────────────────

  Future<PaginatedMessagesResponse> getAllMessages({
    String? targetUserId,
    String? groupId,
    int page = 1,
  }) {
    return repo.getAllMessages(
      targetUserId: targetUserId,
      groupId: groupId,
      page: page,
    );
  }

  // ─── Create Group ──────────────────────────────────────────────────────────

  Future<ChatModel> createGroup({
    required String title,
    required List<String> memberIds,
    String? description,
    String? groupPhoto,
  }) {
    return repo.createGroup(
      title: title,
      memberIds: memberIds,
      description: description,
      groupPhoto: groupPhoto,
    );
  }
  // ─── Edit Message ──────────────────────────────────────────────────────────

  Future<MessageModel> editMessage({
    required String messageId,
    required String newContent,
  }) {
    return repo.editMessage(messageId: messageId, newContent: newContent);
  }

  // ─── Delete Message ────────────────────────────────────────────────────────

  Future<void> deleteMessage({required String messageId}) {
    return repo.deleteMessage(messageId: messageId);
  }
}