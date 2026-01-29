import '../../model/profile_model.dart';

abstract class IProfileDataSource {
  Future<ProfileModel> getMyProfile();
  Future<ProfileModel> getUserProfile(String userId);
  Future<ProfileModel> updateProfile(Map<String, dynamic> updateData);
  Future<void> followUser(String userId);
  Future<void> unfollowUser(String userId);
  Future<void> connectWithUser(String userId);
  Future<void> disconnectFromUser(String userId);
}