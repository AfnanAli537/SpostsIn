class ManualActivateResponse {
  final bool? isSuccess;
  final String? message;
  final String? token;
  final String? userId;
  final String? userType;
  final String? email;
  final String? name;
  final String? expiresAt;
  final String? image;
  final dynamic errors; 

  const ManualActivateResponse({
    this.isSuccess,
    this.message,
    this.token,
    this.userId,
    this.userType,
    this.email,
    this.name,
    this.expiresAt,
    this.image,
    this.errors,
  });

  factory ManualActivateResponse.fromJson(Map<String, dynamic> json) {
    return ManualActivateResponse(
      isSuccess: json['isSuccess'] as bool?,
      message: json['message'] as String?,
      token: json['token'] as String?,
      userId: json['userId'] as String?,
      userType: json['userType'] as String?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      expiresAt: json['expiresAt'] as String?,
      image: json['image'] as String?,
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() => {
        'isSuccess': isSuccess,
        'message': message,
        'token': token,
        'userId': userId,
        'userType': userType,
        'email': email,
        'name': name,
        'expiresAt': expiresAt,
        'image': image,
        'errors': errors,
      };

  @override
  String toString() => 'ManualActivateResponse('
      'isSuccess: $isSuccess, '
      'message: $message, '
      'token: $token, '
      'userId: $userId, '
      'userType: $userType, '
      'email: $email, '
      'name: $name, '
      'expiresAt: $expiresAt, '
      'image: $image, '
      'errors: $errors)';
}
