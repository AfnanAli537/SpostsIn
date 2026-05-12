// Interface
import 'package:sports_in/features/main/courses/model/course_models.dart';

abstract class ICourseDataSource {
  Future<PaginatedCoursesResponse> getAvailableCourses({
    String? searchTerm,
    int? sportTypeId,
    int page = 1,
    int size = 10,
  });
  Future<PaginatedCoursesResponse> getEnrolledCourses({
    String? searchTerm,
    int? sportTypeId,
    int page = 1,
    int size = 10,
  });
  Future<PaginatedCoursesResponse> getCreatedCourses({
    String? searchTerm,
    int? sportTypeId,
    int page = 1,
    int size = 10,
  });
  Future<CourseModel> getCourseById(String courseId);
  Future<CourseModel> createCourse(CreateCourseRequest request);
  Future<CourseModel> updateCourse(UpdateCourseRequest request);
  Future<void> deleteCourse(String courseId);
  Future<List<LessonModel>> getCourseLessons(String courseId);
  Future<LessonModel> createLesson({
    required String courseId,
    required CreateLessonRequest request,
  });
  Future<LessonModel> updateLesson(UpdateLessonRequest request);
  Future<void> deleteLesson(String lessonId);
  Future<void> enrollInCourse(String courseId);
  Future<List<EnrolledUserModel>> getEnrolledUsers(String courseId);
  Future<void> updateLessonProgress({
    required String lessonId,
    required UpdateProgressRequest request,
  });
  Future<RevenueReportModel> getRevenueReport({
    required String courseId,
    int? month,
    int? year,
  });
  // ... all methods
}
