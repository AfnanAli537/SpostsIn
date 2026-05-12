import 'package:injectable/injectable.dart';
import 'package:sports_in/features/main/opportunity/data/model/opp_model.dart';
import 'package:sports_in/features/main/profile/model/profile_model.dart';
import '../interface/i_profile_data_source.dart';

@injectable
class ProfileRepo {
  final IProfileDataSource _dataSource;

  ProfileRepo(this._dataSource);

  Future<ProfileModel> getMyProfile() => _dataSource.getMyProfile();

  Future<ProfileModel> getUserProfile(String userId) =>
      _dataSource.getUserProfile(userId);

  Future<ProfileModel> updateProfile(Map<String, dynamic> updateData) =>
      _dataSource.updateProfile(updateData);

  Future<void> toggleFollow(String userId) => _dataSource.toggleFollow(userId);

  // ── Connection ───────────────────────────────────────────────────────────────

  Future<void> sendConnectionRequest(String receiverId) =>
      _dataSource.sendConnectionRequest(receiverId);

  Future<void> removeContact(String targetId) =>
      _dataSource.removeContact(targetId);

  Future<void> respondConnection({
    required String senderId,
    required String status,
  }) => _dataSource.respondConnection(senderId: senderId, status: status);

  Future<({List<ConnectionRequest> items, bool hasNextPage})>
  getConnectionRequests({int pageNumber = 1, int pageSize = 20}) => _dataSource
      .getConnectionRequests(pageNumber: pageNumber, pageSize: pageSize);

  Future<List<ContactItem>> getContacts({String? userId}) =>
      _dataSource.getContacts(userId: userId);
  Future<({List<UserContactItem> items, bool hasNextPage})> getUserConnections({
    required String userId,
    int pageNumber = 1,
    int pageSize = 20,
  }) => _dataSource.getUserConnections(
    userId: userId,
    pageNumber: pageNumber,
    pageSize: pageSize,
  );

  Future<({List<UserContactItem> items, bool hasNextPage})> getFollowers({
    required String userId,
    int pageNumber = 1,
    int pageSize = 20,
  }) => _dataSource.getFollowers(
    userId: userId,
    pageNumber: pageNumber,
    pageSize: pageSize,
  );

  Future<({List<UserContactItem> items, bool hasNextPage})> getFollowing({
    required String userId,
    int pageNumber = 1,
    int pageSize = 20,
  }) => _dataSource.getFollowing(
    userId: userId,
    pageNumber: pageNumber,
    pageSize: pageSize,
  );
  // ── Achievements ─────────────────────────────────────────────────────────────

  Future<List<Achievement>> getAchievements({
    required String userId,
    int page = 1,
    int size = 10,
  }) => _dataSource.getAchievements(userId: userId, page: page, size: size);

  Future<Achievement> createAchievement({
    required String title,
    required String subtitle,
    required String imageUrl,
    required DateTime date,
  }) => _dataSource.createAchievement(
    title: title,
    subtitle: subtitle,
    imageUrl: imageUrl,
    date: date,
  );

  Future<Achievement> updateAchievement({
    required String achievementId,
    required String title,
    required String subtitle,
    required String imageUrl,
    required DateTime date,
  }) => _dataSource.updateAchievement(
    achievementId: achievementId,
    title: title,
    subtitle: subtitle,
    imageUrl: imageUrl,
    date: date,
  );

  Future<void> deleteAchievement(String achievementId) =>
      _dataSource.deleteAchievement(achievementId);

  // ── Posts ────────────────────────────────────────────────────────────────────

  Future<List<Post>> getPosts({
    required String userId,
    int page = 1,
    int pageSize = 10,
  }) => _dataSource.getPosts(targetUserId: userId, page: page, size: pageSize);

  Future<List<ProfileAd>> getActiveAds({
    required String userId,
    int page = 1,
    int size = 3,
  }) => _dataSource.getActiveAds(userId: userId, page: page, size: size);
  // ── Opportunities ────────────────────────────────────────────────────────────

  Future<PaginatedOpportunitiesResponse> getOpportunities({
    required String userId,
    int page = 1,
    int pageSize = 10,
  }) => _dataSource.getOpportunities(
    userId: userId,
    page: page,
    pageSize: pageSize,
  );

  // ── Courses ──────────────────────────────────────────────────────────────────

  Future<List<Course>> getCourses({
    required String userId,
    int page = 1,
    int pageSize = 10,
  }) => _dataSource.getCourses(userId: userId, page: page, pageSize: pageSize);

  // ── Interests ────────────────────────────────────────────────────────────────

  Future<List<Interest>> getInterests({
    int page = 1,
    int pageSize = 3,
  }) =>
      _dataSource.getInterests( page: page, pageSize: pageSize);
}
