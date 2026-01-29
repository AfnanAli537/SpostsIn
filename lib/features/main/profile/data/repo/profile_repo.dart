import '../interface/i_profile_data_source.dart';
import '../../model/profile_model.dart';

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

  Future<void> followUser(String userId) async {
    await _dataSource.followUser(userId);
  }

  Future<void> unfollowUser(String userId) async {
    await _dataSource.unfollowUser(userId);
  }

  Future<void> connectWithUser(String userId) async {
    await _dataSource.connectWithUser(userId);
  }

  Future<void> disconnectFromUser(String userId) async {
    await _dataSource.disconnectFromUser(userId);
  }
}