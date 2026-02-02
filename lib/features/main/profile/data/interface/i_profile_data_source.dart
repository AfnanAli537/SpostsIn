import 'package:sports_in/features/main/profile/model/profile_model.dart';

abstract class IProfileDataSource {
  Future<ProfileModel> getMyProfile();
  Future<ProfileModel> getUserProfile(String userId);
  Future<ProfileModel> updateProfile(Map<String, dynamic> updateData);
  
  // Toggle methods (single endpoint handles both states)
  Future<void> toggleFollow(String userId);
  Future<void> toggleConnect(String userId);
  
  // Optional: Pagination methods for sections
  Future<List<Post>> getPosts({
    required String userId,
    int page = 1,
    int pageSize = 10,
  });
  
  Future<List<Opportunity>> getOpportunities({
    required String userId,
    int page = 1,
    int pageSize = 10,
  });
  
  Future<List<Course>> getCourses({
    required String userId,
    int page = 1,
    int pageSize = 10,
  });
  
  Future<List<Interest>> getInterests({
    required String userId,
    int page = 1,
    int pageSize = 10,
  });
}