///✅ ─── Chat Model ───────────────────────────────────────────────
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

  /// Parses API datetime; if no timezone (Z or +00:00), treats as UTC to fix 2h diff.
  static DateTime? _parseDateTimeUtc(dynamic value) {
    final str = value?.toString().trim() ?? '';
    if (str.isEmpty) return null;
    final hasTz = str.endsWith('Z') || RegExp(r'[+-]\d{2}:?\d{2}$').hasMatch(str);
    return DateTime.tryParse(hasTz ? str : '${str}Z');
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['targetId']?.toString() ?? '',
      title: json['name'] ?? '',
      groupPhoto: json['imageUrl'],
      isGroup: json['isGroup'] ?? false,
      members: [], // API does not return members here
      lastMessage: json['lastMessage']?.toString(),
      lastMessageTime:
          _parseDateTimeUtc(json['lastMessageTime']) ?? DateTime.now(),
      unreadCount: json['unreadCount'] ?? 0,
      isOnline: json['isOnline'] ?? false,
      lastMessageStatus: json['lastMessageStatus'],
    );
  }
}

//✅ ─── Chat Member Model ─────────────────────────────────────────
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

///✅ ─── Paginated Response ───────────────────────────────────────
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
