

abstract class IAuthDataSource {
  Future<void> logout();
  Future<Map<String,dynamic>?> getCachedUser();
 
}