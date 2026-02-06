class AuthorModel {
  final String userId;
  final String fullName;
  final String? profilePictureUrl;

  AuthorModel({
    required this.userId,
    required this.fullName,
    this.profilePictureUrl,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      userId: json['userId'],
      fullName: json['fullName'],
      profilePictureUrl: json['profilePictureUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'fullName': fullName,
        'profilePictureUrl': profilePictureUrl,
      };
}
