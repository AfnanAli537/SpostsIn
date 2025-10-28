abstract class IAuthDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<void> logout();
  Future<Map<String,dynamic>?> getCachedUser();
  
}