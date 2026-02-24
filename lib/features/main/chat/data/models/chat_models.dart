// ─── Message Model ────────────────────────────────────────────────────────────

class MessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final String content;
  final String? attachmentUrl;
  final DateTime sentAt;
  final bool isEdited;
  final bool isDeleted;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.content,
    this.attachmentUrl,
    required this.sentAt,
    required this.isEdited,
    required this.isDeleted,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: json['id']?.toString() ?? '',
        senderId: json['senderId']?.toString() ?? '',
        senderName: json['senderName'] ?? '',
        senderAvatar: json['senderAvatar'],
        content: json['content'] ?? '',
        attachmentUrl: json['attachmentUrl'],
        sentAt: DateTime.tryParse(json['sentAt'] ?? '') ?? DateTime.now(),
        isEdited: json['isEdited'] ?? false,
        isDeleted: json['isDeleted'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'senderName': senderName,
        'senderAvatar': senderAvatar,
        'content': content,
        'attachmentUrl': attachmentUrl,
        'sentAt': sentAt.toIso8601String(),
        'isEdited': isEdited,
        'isDeleted': isDeleted,
      };
}

// ─── Chat / Conversation Model ────────────────────────────────────────────────

class ChatModel {
  final String id;
  final String? title;        // group title (null for direct chats)
  final String? description;  // group description (null for direct chats)
  final bool isGroup;
  final String? groupPhoto;
  final List<ChatMemberModel> members;
  final MessageModel? lastMessage;
  final int unreadCount;
  final DateTime? updatedAt;

  const ChatModel({
    required this.id,
    this.title,
    this.description,
    required this.isGroup,
    this.groupPhoto,
    required this.members,
    this.lastMessage,
    required this.unreadCount,
    this.updatedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        id: json['id']?.toString() ?? '',
        title: json['title'],
        description: json['description'],
        isGroup: json['isGroup'] ?? false,
        groupPhoto: json['groupPhoto'],
        members: (json['members'] as List? ?? [])
            .map((e) => ChatMemberModel.fromJson(e))
            .toList(),
        lastMessage: json['lastMessage'] != null
            ? MessageModel.fromJson(json['lastMessage'])
            : null,
        unreadCount: json['unreadCount'] ?? 0,
        updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
      );
}

// ─── Chat Member Model ────────────────────────────────────────────────────────

class ChatMemberModel {
  final String userId;
  final String userName;
  final String? avatar;
  final bool isAdmin;

  const ChatMemberModel({
    required this.userId,
    required this.userName,
    this.avatar,
    required this.isAdmin,
  });

  factory ChatMemberModel.fromJson(Map<String, dynamic> json) =>
      ChatMemberModel(
        userId: json['userId']?.toString() ?? '',
        userName: json['userName'] ?? '',
        avatar: json['avatar'],
        isAdmin: json['isAdmin'] ?? false,
      );
}

// ─── Contact Model ────────────────────────────────────────────────────────────

class ContactModel {
  final String userId;
  final String userName;
  final String? avatar;
  final String? bio;

  const ContactModel({
    required this.userId,
    required this.userName,
    this.avatar,
    this.bio,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        userId: json['userId']?.toString() ?? '',
        userName: json['userName'] ?? '',
        avatar: json['avatar'],
        bio: json['bio'],
      );
}

// ─── Paginated Responses ──────────────────────────────────────────────────────

class PaginatedChatsResponse {
  final List<ChatModel> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginatedChatsResponse({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedChatsResponse.fromJson(Map<String, dynamic> json) =>
      PaginatedChatsResponse(
        items: (json['items'] as List? ?? [])
            .map((e) => ChatModel.fromJson(e))
            .toList(),
        totalCount: json['totalCount'] ?? 0,
        pageNumber: json['pageNumber'] ?? 1,
        pageSize: json['pageSize'] ?? 10,
        totalPages: json['totalPages'] ?? 0,
        hasNextPage: json['hasNextPage'] ?? false,
        hasPreviousPage: json['hasPreviousPage'] ?? false,
      );
}

class PaginatedMessagesResponse {
  final List<MessageModel> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginatedMessagesResponse({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedMessagesResponse.fromJson(Map<String, dynamic> json) =>
      PaginatedMessagesResponse(
        items: (json['items'] as List? ?? [])
            .map((e) => MessageModel.fromJson(e))
            .toList(),
        totalCount: json['totalCount'] ?? 0,
        pageNumber: json['pageNumber'] ?? 1,
        pageSize: json['pageSize'] ?? 10,
        totalPages: json['totalPages'] ?? 0,
        hasNextPage: json['hasNextPage'] ?? false,
        hasPreviousPage: json['hasPreviousPage'] ?? false,
      );
}

class PaginatedContactsResponse {
  final List<ContactModel> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginatedContactsResponse({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedContactsResponse.fromJson(Map<String, dynamic> json) =>
      PaginatedContactsResponse(
        items: (json['items'] as List? ?? [])
            .map((e) => ContactModel.fromJson(e))
            .toList(),
        totalCount: json['totalCount'] ?? 0,
        pageNumber: json['pageNumber'] ?? 1,
        pageSize: json['pageSize'] ?? 10,
        totalPages: json['totalPages'] ?? 0,
        hasNextPage: json['hasNextPage'] ?? false,
        hasPreviousPage: json['hasPreviousPage'] ?? false,
      );
}

// ─── Send Message Request Model ───────────────────────────────────────────────
// POST /api/Chat/send — multipart/form-data
// Fields: Content, Attachment (binary), ReceiverId, GroupId

class SendMessageRequest {
  final String content;
  final String? receiverId;     // for direct messages
  final String? groupId;        // for group messages
  final String? attachmentFile; // local file path → sent as binary

  const SendMessageRequest({
    required this.content,
    this.receiverId,
    this.groupId,
    this.attachmentFile,
  }) : assert(
          receiverId != null || groupId != null,
          'Either receiverId or groupId must be provided',
        );
}

// ─── Create Group Request Model ───────────────────────────────────────────────
// POST /api/Chat/group/create — multipart/form-data
// Fields: Title* (string), Description (string), GroupPhoto (binary), MemberIds* (array<string>)

class CreateGroupRequest {
  final String title;
  final List<String> memberIds;
  final String? description;
  final String? groupPhoto; // local file path → sent as binary

  const CreateGroupRequest({
    required this.title,
    required this.memberIds,
    this.description,
    this.groupPhoto,
  });
}