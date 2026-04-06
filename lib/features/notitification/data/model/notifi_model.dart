class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type;
  final String? relatedEntityId;
  final bool isRead;
  final DateTime createdAt;
  final String? senderId;
  final String? senderName;
  final String? senderImage;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.relatedEntityId,
    required this.isRead,
    required this.createdAt,
    this.senderId,
    this.senderName,
    this.senderImage,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? '',
      relatedEntityId: json['relatedEntityId'],
      isRead: json['isRead'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      senderId: json['senderId'],
      senderName: json['senderName'],
      senderImage: json['senderImage'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'type': type,
        'relatedEntityId': relatedEntityId,
        'isRead': isRead,
        'createdAt': createdAt.toIso8601String(),
        'senderId': senderId,
        'senderName': senderName,
        'senderImage': senderImage,
      };

  NotificationModel copyWith({bool? isRead}) => NotificationModel(
        id: id,
        title: title,
        body: body,
        type: type,
        relatedEntityId: relatedEntityId,
        isRead: isRead ?? this.isRead,
        createdAt: createdAt,
        senderId: senderId,
        senderName: senderName,
        senderImage: senderImage,
      );
}

class PaginatedNotificationsResponse {
  final List<NotificationModel> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginatedNotificationsResponse({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginatedNotificationsResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedNotificationsResponse(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: json['totalCount'] ?? 0,
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 20,
      totalPages: json['totalPages'] ?? 1,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
    );
  }
}