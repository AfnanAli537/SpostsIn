


// ─── Message Model ────────────────────────────────────────────────────────────

class MessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  String content;         // ✅ non-final → mutable for optimistic edit
  final String? attachmentUrl;
  final DateTime sentAt;
  bool isEdited;          // ✅ non-final → mutable for optimistic edit
  final bool isDeleted;
  final bool isMe;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.content,
    this.attachmentUrl,
   required this.isMe,
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
        isMe: json['isMe']??false
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

// ─── Chat Member Model ────────────────────────────────────────────────────────

class ChatMemberModel {
  final String userId;
  final String userName;
  final String? avatar;
  final String? bio;      // ✅ added — used in contacts list & create group
  final bool isAdmin;

  const ChatMemberModel({
    required this.userId,
    required this.userName,
    this.avatar,
    this.bio,
    this.isAdmin = false, // ✅ default false — no need to pass it every time
  });

  factory ChatMemberModel.fromJson(Map<String, dynamic> json) => ChatMemberModel(
        userId: json['userId']?.toString() ?? '',
        userName: json['userName'] ?? '',
        avatar: json['avatar'],
        bio: json['bio'],
        isAdmin: json['isAdmin'] ?? false,
      );
}

// ✅ ContactModel is now a typedef alias for ChatMemberModel
// This fixes: "The element type 'ContactModel' can't be assigned to 'ChatMemberModel'"
// All existing ContactModel usage keeps working without any changes
typedef ContactModel = ChatMemberModel;

// ─── Chat / Conversation Model ────────────────────────────────────────────────

class ChatModel {
  final String id;
  final String? title;
  final String? description;
  final bool isGroup;
  final String? groupPhoto;
  final List<ChatMemberModel> members;
  final MessageModel? lastMessage;
  final int unreadCount;
  final DateTime? updatedAt;

  ChatModel({                   // ✅ removed const — List can't always be const
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

  // ✅ Safe display name — no more widget.chat.title! crashes
  String get displayName =>
      isGroup ? (title ?? 'Group') : (members.firstOrNull?.userName ?? '');

  // ✅ Safe display avatar
  String? get displayAvatar =>
      isGroup ? groupPhoto : members.firstOrNull?.avatar;
factory ChatModel.fromJson(Map<String, dynamic> json) {
  final lastMsg = json['lastMessage'];

  MessageModel? parsedLastMessage;

  if (lastMsg is Map<String, dynamic>) {
    parsedLastMessage = MessageModel.fromJson(lastMsg);
  } else if (lastMsg is String) {
    parsedLastMessage = MessageModel(
      id: '',
      senderId: json['targetId'] ?? '',
    senderName: json['senderName'] ?? 'User',
      content: lastMsg,
      sentAt: DateTime.tryParse(json['lastMessageTime'] ?? '') ?? DateTime.now(),
      isEdited: false,
      isDeleted: false,
      isMe: json['isMe']??false
    );
  }

  return ChatModel(
    id: json['targetId'] ?? '',
    title: json['name'] ?? 'Chat',
    // title: json['name'],
    description: null,
    isGroup: json['isGroup'] ?? false,
    groupPhoto: json['imageUrl'],
    members: [],
    lastMessage: parsedLastMessage,
    unreadCount: json['unreadCount'] ?? 0,
    updatedAt: DateTime.tryParse(json['lastMessageTime'] ?? ''),
  );
}
  // factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
  //       id: json['id']?.toString() ?? '',
  //       title: json['title'],
  //       description: json['description'],
  //       isGroup: json['isGroup'] ?? false,
  //       groupPhoto: json['groupPhoto'],
  //       members: (json['members'] as List? ?? [])
  //           .map((e) => ChatMemberModel.fromJson(e))
  //           .toList(),
  //       lastMessage: json['lastMessage'] != null
  //           ? MessageModel.fromJson(json['lastMessage'])
  //           : null,
  //       unreadCount: json['unreadCount'] ?? 0,
  //       updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
  //     );

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
//   factory PaginatedChatsResponse.fromJson(dynamic json) {
//   if (json is List) {
//     return PaginatedChatsResponse(
//       items: json.map((e) => ChatModel.fromJson(e)).toList(),
//       totalCount: json.length,
//       pageNumber: 1,
//       pageSize: json.length,
//       totalPages: 1,
//       hasNextPage: false,
//       hasPreviousPage: false,
//     );
//   }

//   return PaginatedChatsResponse(
//     items: (json['items'] as List? ?? [])
//         .map((e) => ChatModel.fromJson(e))
//         .toList(),
//     totalCount: json['totalCount'] ?? 0,
//     pageNumber: json['pageNumber'] ?? 1,
//     pageSize: json['pageSize'] ?? 10,
//     totalPages: json['totalPages'] ?? 0,
//     hasNextPage: json['hasNextPage'] ?? false,
//     hasPreviousPage: json['hasPreviousPage'] ?? false,
//   );
// }

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

// ✅ Now returns List<ChatMemberModel> — fixes BLoC state type mismatch
class PaginatedContactsResponse {
  final List<ChatMemberModel> items;   // ✅ was List<ContactModel>
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
            .map((e) => ChatMemberModel.fromJson(e))  // ✅ was ContactModel.fromJson
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

class SendMessageRequest {
  final String content;
  final String? receiverId;
  final String? groupId;
  final String? attachmentFile;

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

class CreateGroupRequest {
  final String title;
  final List<String> memberIds;
  final String? description;
  final String? groupPhoto;

  const CreateGroupRequest({
    required this.title,
    required this.memberIds,
    this.description,
    this.groupPhoto,
  });
}


