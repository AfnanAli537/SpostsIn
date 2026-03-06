///✅ ─── Message Model ───────────────────────────────────────────────
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

  /// Parses API datetime; if no timezone (Z or +00:00), treats as UTC to fix 2h diff.
  static DateTime? _parseDateTimeUtc(dynamic value) {
    final str = value?.toString().trim() ?? '';
    if (str.isEmpty) return null;
    final hasTz = str.endsWith('Z') || RegExp(r'[+-]\d{2}:?\d{2}$').hasMatch(str);
    return DateTime.tryParse(hasTz ? str : '${str}Z');
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? '',
      senderName: json['senderName'] ?? '',
      senderAvatar: json['senderAvatar'],
      content: json['content'] ?? '',
      attachmentUrl: json['attachmentUrl'],
      sentAt: _parseDateTimeUtc(json['sentAt']) ?? DateTime.now(),
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

  MessageModel copyWith({
    String? content,
    bool? isEdited,
    bool? isDeleted,
    int? status,
  }) {
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
      status: status ?? this.status,
    );
  }
}

///✅ ─── Paginated Response ───────────────────────────────────────

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
