import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:sports_in/core/error/api_error_handler.dart';
import 'package:sports_in/core/network/api_client.dart';
import 'package:sports_in/core/network/endpoints.dart';
import '../interface/i_course_data_source.dart';
import '../../model/course_models.dart';

@LazySingleton(as: ICourseDataSource)
class CourseRemoteDataSource implements ICourseDataSource {
  final ApiClient _apiClient;

  CourseRemoteDataSource(this._apiClient);

  DioException _badResponse(Response response) => DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );

  // ==================== BROWSE & DISCOVERY ====================

  @override
  Future<PaginatedCoursesResponse> getAvailableCourses({
    String? searchTerm,
    int? sportTypeId,
    int page = 1,
    int size = 10,
  }) async {
    try {
      debugPrint('Fetching available courses - page: $page, size: $size');
      
      final response = await _apiClient.get(
        Endpoints.availableCourses,
        params: {
          if (searchTerm != null && searchTerm.isNotEmpty)
            'searchTerm': searchTerm,
          if (sportTypeId != null) 'sportTypeId': sportTypeId,
          'page': page,
          'size': size,
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Available courses loaded successfully');
        return PaginatedCoursesResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<PaginatedCoursesResponse> getEnrolledCourses({
    String? searchTerm,
    int? sportTypeId,
    int page = 1,
    int size = 10,
  }) async {
    try {
      debugPrint('Fetching enrolled courses - page: $page, size: $size');
      
      final response = await _apiClient.get(
        Endpoints.enrolledCourses,
        params: {
          if (searchTerm != null && searchTerm.isNotEmpty)
            'searchTerm': searchTerm,
          if (sportTypeId != null) 'sportTypeId': sportTypeId,
          'page': page,
          'size': size,
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Enrolled courses loaded successfully');
        return PaginatedCoursesResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<PaginatedCoursesResponse> getCreatedCourses({
    String? searchTerm,
    int? sportTypeId,
    int page = 1,
    int size = 10,
  }) async {
    try {
      debugPrint('Fetching created courses - page: $page, size: $size');
      
      final response = await _apiClient.get(
        Endpoints.createdCourses,
        params: {
          if (searchTerm != null && searchTerm.isNotEmpty)
            'searchTerm': searchTerm,
          if (sportTypeId != null) 'sportTypeId': sportTypeId,
          'page': page,
          'size': size,
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Created courses loaded successfully');
        return PaginatedCoursesResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ==================== COURSE CRUD ====================

  @override
  Future<CourseModel> getCourseById(String courseId) async {
    try {
      debugPrint('Fetching course details for ID: $courseId');
      
      final response = await _apiClient.get(
        Endpoints.courseById.replaceAll('{id}', courseId),
      );

      if (response.statusCode == 200) {
        debugPrint('Course details loaded successfully');
        return CourseModel.fromJson(response.data as Map<String, dynamic>);
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<CourseModel> createCourse(CreateCourseRequest request) async {
    try {
      debugPrint('Creating new course: ${request.title}');
      
      final formData = FormData.fromMap({
        'Title': request.title,
        'Description': request.description,
        'Price': request.price,
        'SportTypeId': request.sportTypeId,
      });

      if (request.thumbnailFile != null) {
        formData.files.add(
          MapEntry(
            'ThumbnailFile',
            await MultipartFile.fromFile(
              request.thumbnailFile!.path,
              filename: request.thumbnailFile!.path.split('/').last,
            ),
          ),
        );
      }

      final response = await _apiClient.post(
        Endpoints.createCourse,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Course created successfully');
        return CourseModel.fromJson(response.data as Map<String, dynamic>);
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<CourseModel> updateCourse(UpdateCourseRequest request) async {
    try {
      debugPrint('Updating course: ${request.id}');
      
      final formData = FormData.fromMap({
        'Title': request.title,
        'Description': request.description,
        'Price': request.price,
        'SportTypeId': request.sportTypeId,
      });

      if (request.thumbnail is File) {
      formData.files.add(
        MapEntry(
          'ThumbnailFile',
          await MultipartFile.fromFile(
            request.thumbnail!.path,
            filename: request.thumbnail!.path.split('/').last,
          ),
        ),
      );
    } else if (request.thumbnail is String) {
      formData.fields.add(MapEntry('ThumbnailFile', request.thumbnail));
    }

      final response = await _apiClient.put(
        Endpoints.updateCourse.replaceAll('{id}', request.id),
        data: formData,
        options: Options(
          contentType: Headers.multipartFormDataContentType,
        ),
      );

      if (response.statusCode == 200) {
        debugPrint('Course updated successfully');
        return CourseModel.fromJson(response.data as Map<String, dynamic>);
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> deleteCourse(String courseId) async {
    try {
      debugPrint('Deleting course: $courseId');
      
      final response = await _apiClient.delete(
        Endpoints.deleteCourse.replaceAll('{id}', courseId),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint('Course deleted successfully');
        return;
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ==================== LESSONS ====================

  @override
  Future<List<LessonModel>> getCourseLessons(String courseId) async {
    try {
      debugPrint('Fetching lessons for course: $courseId');
      
      final response = await _apiClient.get(
        Endpoints.courseLessons.replaceAll('{id}', courseId),
      );

      if (response.statusCode == 200) {
        debugPrint('Lessons loaded successfully');
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<LessonModel> createLesson({
    required String courseId,
    required CreateLessonRequest request,
  }) async {
    try {
      debugPrint('Creating lesson for course: $courseId');
      
      final formData = FormData.fromMap({
        'Title': request.title,
        'Description': request.description,
        'Duration': request.duration,
        if (request.order != null) 'Order': request.order,
      });

      formData.files.add(
        MapEntry(
          'VideoFile',
          await MultipartFile.fromFile(
            request.videoFile.path,
            filename: request.videoFile.path.split('/').last,
          ),
        ),
      );

      final response = await _apiClient.post(
        Endpoints.addLesson.replaceAll('{courseId}', courseId),
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Lesson created successfully');
        return LessonModel.fromJson(response.data as Map<String, dynamic>);
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<LessonModel> updateLesson(UpdateLessonRequest request) async {
    try {
      debugPrint('Updating lesson: ${request.lessonId}');
      
      final formData = FormData.fromMap({
        'Title': request.title,
        'Description': request.description,
        'Duration': request.duration,
        'Order': request.order,
      });

      if (request.video is File) {
      formData.files.add(
        MapEntry(
          'VideoFile',
          await MultipartFile.fromFile(
            request.video!.path,
            filename: request.video!.path.split('/').last,
          ),
        ),
      );
    } else if (request.video is String) {
      // Send existing URL as field (backend should handle this)
      formData.fields.add(MapEntry('VideoFile', request.video));
    }

      final response = await _apiClient.put(
        Endpoints.updateLesson.replaceAll('{lessonId}', request.lessonId),
        data: formData,
        options: Options(
        contentType: Headers.multipartFormDataContentType,
      ),
      );

      if (response.statusCode == 200) {
        debugPrint('Lesson updated successfully');
        return LessonModel.fromJson(response.data as Map<String, dynamic>);
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<void> deleteLesson(String lessonId) async {
    try {
      debugPrint('Deleting lesson: $lessonId');
      
      final response = await _apiClient.delete(
        Endpoints.deleteLesson.replaceAll('{lessonId}', lessonId),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint('Lesson deleted successfully');
        return;
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ==================== ENROLLMENT ====================

  @override
  Future<void> enrollInCourse(String courseId) async {
    try {
      debugPrint('Enrolling in course: $courseId');
      
      final response = await _apiClient.post(
        Endpoints.enrollCourse.replaceAll('{id}', courseId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Enrolled successfully');
        return;
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  @override
  Future<List<EnrolledUserModel>> getEnrolledUsers(String courseId) async {
    try {
      debugPrint('Fetching enrolled users for course: $courseId');
      
      final response = await _apiClient.get(
        Endpoints.enrolledUsers.replaceAll('{id}', courseId),
      );

      if (response.statusCode == 200) {
        debugPrint('Enrolled users loaded successfully');
        final List<dynamic> data = response.data as List<dynamic>;
        return data
            .map((e) => EnrolledUserModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ==================== PROGRESS TRACKING ====================

  @override
  Future<void> updateLessonProgress({
    required String lessonId,
    required UpdateProgressRequest request,
  }) async {
    try {
      debugPrint('Updating progress for lesson: $lessonId');
      
      final response = await _apiClient.post(
        Endpoints.lessonProgress.replaceAll('{lessonId}', lessonId),
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint('Progress updated successfully');
        return;
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }

  // ==================== ANALYTICS (PROVIDER) ====================

  @override
  Future<RevenueReportModel> getRevenueReport({
    required String courseId,
    int? month,
    int? year,
  }) async {
    try {
      debugPrint('Fetching revenue report for course: $courseId');
      
      final response = await _apiClient.get(
        Endpoints.revenueReport.replaceAll('{courseId}', courseId),
        params: {
          if (month != null) 'month': month,
          if (year != null) 'year': year,
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Revenue report loaded successfully');
        return RevenueReportModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      }

      throw ApiErrorHandler.handleDioError(_badResponse(response));
    } on DioException catch (e) {
      throw ApiErrorHandler.handleDioError(e);
    }
  }
}