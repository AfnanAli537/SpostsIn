///✅ ─── Contacts Model ─────────────────────────────────────────────
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

///✅ ─── Paginated Response ───────────────────────────────────────
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
