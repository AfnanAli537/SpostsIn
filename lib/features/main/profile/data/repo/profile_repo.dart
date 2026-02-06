import 'package:injectable/injectable.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';

import '../interface/i_profile_data_source.dart';

@injectable
class ProfileRepo {
  final IProfileDataSource _dataSource;

  ProfileRepo(this._dataSource);

  Future<ProfileModel> getMyProfile() async {
    return await _dataSource.getMyProfile();
  }

  Future<ProfileModel> getUserProfile(String userId) async {
    return await _dataSource.getUserProfile(userId);
  }

  Future<ProfileModel> updateProfile(Map<String, dynamic> updateData) async {
    return await _dataSource.updateProfile(updateData);
  }

  // Toggle follow - handles both follow and unfollow
  Future<void> toggleFollow(String userId) async {
    await _dataSource.toggleFollow(userId);
  }

  // Toggle connect - handles both connect and disconnect
  Future<void> toggleConnect(String userId) async {
    await _dataSource.toggleConnect(userId);
  }

  // Achievement methods
  Future<List<Achievement>> getAchievements({
    required String userId,
    int page = 1,
    int size = 10,
  }) async {
    return await _dataSource.getAchievements(
      userId: userId,
      page: page,
      size: size,
    );
  }

  Future<Achievement> createAchievement({
    required String title,
    required String subtitle,
    required String imageUrl,
    required DateTime date,
  }) async {
    return await _dataSource.createAchievement(
      title: title,
      subtitle: subtitle,
      imageUrl: imageUrl,
      date: date,
    );
  }

  Future<Achievement> updateAchievement({
    required String achievementId,
    required String title,
    required String subtitle,
    required String imageUrl,
    required DateTime date,
  }) async {
    return await _dataSource.updateAchievement(
      achievementId: achievementId,
      title: title,
      subtitle: subtitle,
      imageUrl: imageUrl,
      date: date,
    );
  }

  Future<void> deleteAchievement(String achievementId) async {
    await _dataSource.deleteAchievement(achievementId);
  }

  // Posts
  Future<List<Post>> getPosts({
    required String userId,
    int page = 1,
    int pageSize = 10,
  }) async {
    return await _dataSource.getPosts(
      targetUserId: userId,
      page: page,
      size: pageSize,
    );
  }

  // Opportunities
  Future<List<Opportunity>> getOpportunities({
    required String userId,
    int page = 1,
    int pageSize = 10,
  }) async {
    return await _dataSource.getOpportunities(
      userId: userId,
      page: page,
      pageSize: pageSize,
    );
  }

  // Courses
  Future<List<Course>> getCourses({
    required String userId,
    int page = 1,
    int pageSize = 10,
  }) async {
    return await _dataSource.getCourses(
      userId: userId,
      page: page,
      pageSize: pageSize,
    );
  }

  // Interests
  Future<List<Interest>> getInterests({
    required String userId,
    int page = 1,
    int pageSize = 10,
  }) async {
    return await _dataSource.getInterests(
      userId: userId,
      page: page,
      pageSize: pageSize,
    );
  }
}