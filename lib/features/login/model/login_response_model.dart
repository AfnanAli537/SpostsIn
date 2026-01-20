class LoginResponse {
  final bool isSuccess;
  final String message;
  final String? token;
  final String? userId;
  final String? userType;
  final String? email;
  final UserName? name;
  final DateTime? expiresAt;

  LoginResponse({
    required this.isSuccess,
    required this.message,
     this.token,
     this.userId,
     this.userType,
     this.email,
     this.name,
     this.expiresAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      userId: json['userId'] ?? '',
      userType: json['userType'] ?? '',
      email: json['email'] ?? '',
      name: UserName.fromJson(json['name'] ?? {}),
      expiresAt: DateTime.tryParse(json['expiresAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'message': message,
      'token': token,
      'userId': userId,
      'userType': userType,
      'email': email,
      'name': name?.toJson(),
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }
}

class UserName {
  final String firstName;
  final String secondName;

  UserName({
    required this.firstName,
    required this.secondName,
  });

  factory UserName.fromJson(Map<String, dynamic> json) {
    return UserName(
      firstName: json['firstName'] ?? '',
      secondName: json['secondName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'secondName': secondName,
    };
  }
}









// class LoginResponse {
//   final String token;
//   final String? message;

//   LoginResponse({required this.token, this.message});

//   factory LoginResponse.fromJson(Map<String, dynamic> json) {
//     return LoginResponse(
//       token: json['token'] ?? '',
//       message: json['message'],
//     );
//   }
// }


// Response body
// {
//   "isSuccess": true,
//   "message": "Login successful!",
//   "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6ImI1MDdkNTU3LTJkZGYtNDczMS1hZDQ0LWVlNWZmNTM3ZDI1NCIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL2VtYWlsYWRkcmVzcyI6InVzZXIxMjM0QGV4YW1wbGUuY29tIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiUGxheWVyIiwianRpIjoiODFjMzRiZDYtNzFkNi00M2MyLWFjMTYtMGRlMmMzYmYxYjQwIiwiaWF0IjoxNzYxNjAxNTgzLCJleHAiOjE3NjIyMDYzODMsImlzcyI6IlNwb3J0c0luIiwiYXVkIjoiU3BvcnRzSW5Vc2VycyJ9.MDERClwaPCvKVVlEigXpigcDRADRWYUequFk8CTLsPA",
//   "userId": "b507d557-2ddf-4731-ad44-ee5ff537d254",
//   "userType": "Player",
//   "email": "user1234@example.com",
//   "name": {
//     "firstName": "string",
//     "secondName": "string"
//   },
//   "expiresAt": "2025-11-03T21:46:23.7125702Z"
// }