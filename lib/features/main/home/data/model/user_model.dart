class UserLists {
  final String userId;
  final String fullName;
  final String? profilePhoto;
  final String createdAt;

  UserLists({
    required this.userId,
    required this.fullName,
    this.profilePhoto,
    required this.createdAt,
  });

  factory UserLists.fromJson(Map<String, dynamic> json) {
    return UserLists(
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? '',
      profilePhoto: json['profilePictureUrl'],
      createdAt: json['createdAt'] ?? '',
    );
  }
}