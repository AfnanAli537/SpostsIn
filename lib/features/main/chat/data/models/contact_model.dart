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
      id:
          json['id']?.toString() ??
          json['userId']?.toString() ??
          json['targetId']?.toString() ??
          '',
      name: (json['title'] ?? json['userName'] ?? json['name'] ?? '')
          .toString()
          .trim(),
      avatar: (json['imageUrl'] ?? json['avatar'])?.toString(),
      bio: (json['bio'] ?? json['description'])?.toString(),
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
