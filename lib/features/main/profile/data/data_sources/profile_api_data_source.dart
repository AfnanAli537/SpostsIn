// import 'package:dio/dio.dart';
// import '../interface/i_profile_data_source.dart';
// import '../../model/profile_model.dart';

// class ProfileApiDataSource implements IProfileDataSource {
//   final Dio _dio;
  
//   ProfileApiDataSource(this._dio);

//   @override
//   Future<ProfileModel> getMyProfile() async {
//     try {
//       final response = await _dio.get('/profile/me');
//       return ProfileModel.fromJson(response.data['data']);
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }

//   @override
//   Future<ProfileModel> getUserProfile(String userId) async {
//     try {
//       final response = await _dio.get('/profile/$userId');
//       return ProfileModel.fromJson(response.data['data']);
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }

//   @override
//   Future<ProfileModel> updateProfile(Map<String, dynamic> updateData) async {
//     try {
//       final response = await _dio.put(
//         '/profile/me',
//         data: updateData,
//       );
//       return ProfileModel.fromJson(response.data['data']);
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }

//   @override
//   Future<void> followUser(String userId) async {
//     try {
//       await _dio.post('/profile/$userId/follow');
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }

//   @override
//   Future<void> unfollowUser(String userId) async {
//     try {
//       await _dio.delete('/profile/$userId/follow');
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }

//   @override
//   Future<void> connectWithUser(String userId) async {
//     try {
//       await _dio.post('/profile/$userId/connect');
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }

//   @override
//   Future<void> disconnectFromUser(String userId) async {
//     try {
//       await _dio.delete('/profile/$userId/connect');
//     } on DioException catch (e) {
//       throw _handleError(e);
//     }
//   }

//   Exception _handleError(DioException error) {
//     if (error.response != null) {
//       final message = error.response?.data['message'] ?? 'An error occurred';
//       return Exception(message);
//     } else {
//       return Exception('Network error: ${error.message}');
//     }
//   }
// }