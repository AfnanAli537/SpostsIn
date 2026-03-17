import '../../model/profile_model.dart';

abstract class IProfileDataSource {
  Future<ProfileModel> getMyProfile();
  Future<ProfileModel> getUserProfile(String userId);
  Future<ProfileModel> updateProfile(Map<String, dynamic> updateData);

  Future<List<Post>> getPosts({
    required String targetUserId,
    int page = 1,
    int size = 10,
  });
  Future<List<ProfileAd>> getActiveAds({
    required String userId,
    int page = 1,
    int size = 3,
  });
  Future<List<Achievement>> getAchievements({
    required String userId,
    int page = 1,
    int size = 10,
  });

  Future<Achievement> createAchievement({
    required String title,
    required String subtitle,
    required String imageUrl,
    required DateTime date,
  });

  Future<Achievement> updateAchievement({
    required String achievementId,
    required String title,
    required String subtitle,
    required String imageUrl,
    required DateTime date,
  });

  Future<void> deleteAchievement(String achievementId);

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

  Future<void> toggleFollow(String userId);

  Future<void> sendConnectionRequest(String receiverId);

  Future<void> removeContact(String targetId);

  Future<void> respondConnection({
    required String senderId,
    required String status,
  });

  Future<({List<ConnectionRequest> items, bool hasNextPage})>
  getConnectionRequests({int pageNumber = 1, int pageSize = 20});

  Future<List<ContactItem>> getContacts({String? userId});
}
