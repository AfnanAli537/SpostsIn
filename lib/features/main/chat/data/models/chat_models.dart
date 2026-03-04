// ─── Message Model ───────────────────────────────────────────────
class MessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  String content;
  final String? attachmentUrl;
  final DateTime sentAt;
  bool isEdited;
  bool isDeleted;
  final bool isMe;
  final int? status;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.content,
    this.attachmentUrl,
    required this.sentAt,
    this.isEdited = false,
    this.isDeleted = false,
    this.isMe = false,
    this.status,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? '',
      senderName: json['senderName'] ?? '',
      senderAvatar: json['senderAvatar'],
      content: json['content'] ?? '',
      attachmentUrl: json['attachmentUrl'],
      sentAt: DateTime.tryParse(json['sentAt'] ?? '') ?? DateTime.now(),
      isEdited: json['isEdited'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      isMe: json['isMe'] ?? false,
      status: json['status'],
    );
  }

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
    'isMe': isMe,
    'status': status,
  };

  MessageModel copyWith({String? content, bool? isEdited, bool? isDeleted}) {
    return MessageModel(
      id: id,
      senderId: senderId,
      senderName: senderName,
      senderAvatar: senderAvatar,
      content: content ?? this.content,
      attachmentUrl: attachmentUrl,
      sentAt: sentAt,
      isEdited: isEdited ?? this.isEdited,
      isDeleted: isDeleted ?? this.isDeleted,
      isMe: isMe,
      status: status,
    );
  }
}

// ─── Chat Model ───────────────────────────────────────────────
class ChatModel {
  final String id;
  final String? title;
  final String? groupPhoto;
  final bool isGroup;
  final List<ChatMemberModel> members;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final bool isOnline;
  final int? lastMessageStatus;

  ChatModel({
    required this.id,
    this.title,
    this.groupPhoto,
    required this.isGroup,
    required this.members,
    this.lastMessage,
    this.lastMessageTime,
    required this.unreadCount,
    this.isOnline = false,
    this.lastMessageStatus,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['targetId']?.toString() ?? '',
      title: json['name'] ?? '',
      groupPhoto: json['imageUrl'],
      isGroup: json['isGroup'] ?? false,
      members: [], // API does not return members here
      lastMessage: json['lastMessage']?.toString(),
      lastMessageTime:
          DateTime.tryParse(json['lastMessageTime'] ?? '') ?? DateTime.now(),
      unreadCount: json['unreadCount'] ?? 0,
      isOnline: json['isOnline'] ?? false,
      lastMessageStatus: json['lastMessageStatus'],
    );
  }
}

// ─── Chat Member Model ─────────────────────────────────────────
class ChatMemberModel {
  final String userId;
  final String userName;
  final String? avatar;
  final String? bio;
  final bool isAdmin;

  const ChatMemberModel({
    required this.userId,
    required this.userName,
    this.avatar,
    this.bio,
    this.isAdmin = false,
  });

  factory ChatMemberModel.fromJson(Map<String, dynamic> json) {
    return ChatMemberModel(
      userId: json['userId']?.toString() ?? '',
      userName: json['userName'] ?? '',
      avatar: json['avatar'],
      bio: json['bio'],
      isAdmin: json['isAdmin'] ?? false,
    );
  }
}

// ─── Contacts Model ─────────────────────────────────────────────
class ContactModel {
  final String id;
  final String name;
  final String? avatar;
  final String? bio;
  final bool isOnline;

  ContactModel({
    required this.id,
    required this.name,
    this.avatar,
    this.bio,
    this.isOnline = false,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['userId']?.toString() ?? json['targetId']?.toString() ?? '',
      name: json['userName'] ?? json['name'] ?? '',
      avatar: json['avatar'] ?? json['imageUrl'],
      bio: json['bio'] ?? json['description'] ?? '',
      isOnline: json['isOnline'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': id,
    'userName': name,
    'avatar': avatar,
    'bio': bio,
    'isOnline': isOnline,
  };
}

//  ─── Search Result Model ───────────────────────────────────────
class SearchResultModel {
  final String id;
  final String title;
  final String? imageUrl;
  final String type;
  final bool isOnline;

  SearchResultModel({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.type,
    this.isOnline = false,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'],
      type: json['type'] ?? 'User',
      isOnline: json['isOnline'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'imageUrl': imageUrl,
    'type': type,
    'isOnline': isOnline,
  };
}

// ─── Paginated Response ───────────────────────────────────────
class PaginatedChatsResponse {
  final List<ChatModel> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginatedChatsResponse({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedChatsResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedChatsResponse(
      items: (json['items'] as List? ?? [])
          .map((e) => ChatModel.fromJson(e))
          .toList(),
      totalCount: json['totalCount'] ?? 0,
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
    );
  }
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

  factory PaginatedMessagesResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] ?? [];
    final itemsList = (itemsJson as List)
        .map((e) => MessageModel.fromJson(e))
        .toList();

    return PaginatedMessagesResponse(
      items: itemsList,
      totalCount: json['totalCount'] ?? 0,
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      totalPages: json['totalPages'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
    );
  }
}

class PaginatedContactsResponse {
  final List<ContactModel> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginatedContactsResponse({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedContactsResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] ?? [];
    final itemsList = (itemsJson as List)
        .map((e) => ContactModel.fromJson(e))
        .toList();

    return PaginatedContactsResponse(
      items: itemsList,
      totalCount: json['totalCount'] ?? 0,
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      totalPages: json['totalPages'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
    );
  }
}

class PaginatedSearchResponse {
  final List<SearchResultModel> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginatedSearchResponse({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedSearchResponse.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] ?? [];
    final itemsList = (itemsJson as List)
        .map((e) => SearchResultModel.fromJson(e))
        .toList();

    return PaginatedSearchResponse(
      items: itemsList,
      totalCount: json['totalCount'] ?? 0,
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      totalPages: json['totalPages'] ?? 0,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
    );
  }
}
