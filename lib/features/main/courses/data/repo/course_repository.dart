import 'package:injectable/injectable.dart';
import '../interface/i_course_data_source.dart';
import '../../model/course_models.dart';

@injectable
class CourseRepository {
  final ICourseDataSource _dataSource;

  CourseRepository(this._dataSource);

  // ==================== BROWSE & DISCOVERY ====================

  Future<PaginatedCoursesResponse> getAvailableCourses({
    String? searchTerm,
    int? sportTypeId,
    int page = 1,
    int size = 10,
  }) async {
    return await _dataSource.getAvailableCourses(
      searchTerm: searchTerm,
      sportTypeId: sportTypeId,
      page: page,
      size: size,
    );
  }

  Future<PaginatedCoursesResponse> getEnrolledCourses({
    String? searchTerm,
    int? sportTypeId,
    int page = 1,
    int size = 10,
  }) async {
    return await _dataSource.getEnrolledCourses(
      searchTerm: searchTerm,
      sportTypeId: sportTypeId,
      page: page,
      size: size,
    );
  }

  Future<PaginatedCoursesResponse> getCreatedCourses({
    String? searchTerm,
    int? sportTypeId,
    int page = 1,
    int size = 10,
  }) async {
    return await _dataSource.getCreatedCourses(
      searchTerm: searchTerm,
      sportTypeId: sportTypeId,
      page: page,
      size: size,
    );
  }

  // ==================== COURSE CRUD ====================

  Future<CourseModel> getCourseById(String courseId) async {
    return await _dataSource.getCourseById(courseId);
  }

  Future<CourseModel> createCourse(CreateCourseRequest request) async {
    return await _dataSource.createCourse(request);
  }

  Future<CourseModel> updateCourse(UpdateCourseRequest request) async {
    return await _dataSource.updateCourse(request);
  }

  Future<void> deleteCourse(String courseId) async {
    return await _dataSource.deleteCourse(courseId);
  }

  // ==================== LESSONS ====================

  Future<List<LessonModel>> getCourseLessons(String courseId) async {
    return await _dataSource.getCourseLessons(courseId);
  }

  Future<LessonModel> createLesson({
    required String courseId,
    required CreateLessonRequest request,
  }) async {
    return await _dataSource.createLesson(
      courseId: courseId,
      request: request,
    );
  }

  Future<LessonModel> updateLesson(UpdateLessonRequest request) async {
    return await _dataSource.updateLesson(request);
  }

  Future<void> deleteLesson(String lessonId) async {
    return await _dataSource.deleteLesson(lessonId,);
  }

  // ==================== ENROLLMENT ====================

  Future<void> enrollInCourse(String courseId) async {
    return await _dataSource.enrollInCourse(courseId);
  }

  Future<List<EnrolledUserModel>> getEnrolledUsers(String courseId) async {
    return await _dataSource.getEnrolledUsers(courseId);
  }

  // ==================== PROGRESS ====================

  Future<void> updateLessonProgress({
    required String lessonId,
    required UpdateProgressRequest request,
  }) async {
    return await _dataSource.updateLessonProgress(
      lessonId: lessonId,
      request: request,
    );
  }

  // ==================== ANALYTICS ====================

  Future<RevenueReportModel> getRevenueReport({
    required String courseId,
    int? month,
    int? year,
  }) async {
    return await _dataSource.getRevenueReport(
      courseId: courseId,
      month: month,
      year: year,
    );
  }
}