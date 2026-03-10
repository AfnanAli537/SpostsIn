part of 'courses_bloc.dart';

abstract class CoursesEvent extends Equatable {
  const CoursesEvent();

  @override
  List<Object?> get props => [];
}

// ==================== BROWSE & DISCOVERY ====================

class FetchAvailableCourses extends CoursesEvent {
  final String? searchTerm;
  final int? sportTypeId;
  final int page;
  final int size;
  final bool isRefresh;
  final String source;

  const FetchAvailableCourses({
    this.searchTerm,
    this.sportTypeId,
    this.page = 1,
    this.size = 10,
    this.isRefresh = false,
    this.source = 'coursesTab', // default keeps all existing call sites working
  });

  @override
  List<Object?> get props =>
      [searchTerm, sportTypeId, page, size, isRefresh, source];
}

class FetchEnrolledCourses extends CoursesEvent {
  final String? searchTerm;
  final int? sportTypeId;
  final int page;
  final int size;
  final bool isRefresh;

  const FetchEnrolledCourses({
    this.searchTerm,
    this.sportTypeId,
    this.page = 1,
    this.size = 10,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [searchTerm, sportTypeId, page, size, isRefresh];
}

class FetchCreatedCourses extends CoursesEvent {
  final String? searchTerm;
  final int? sportTypeId;
  final int page;
  final int size;
  final bool isRefresh;

  const FetchCreatedCourses({
    this.searchTerm,
    this.sportTypeId,
    this.page = 1,
    this.size = 10,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [searchTerm, sportTypeId, page, size, isRefresh];
}

// ==================== COURSE DETAIL ====================

class FetchCourseDetail extends CoursesEvent {
  final String courseId;
  const FetchCourseDetail({required this.courseId});
  @override
  List<Object?> get props => [courseId];
}

class FetchCourseLessons extends CoursesEvent {
  final String courseId;
  const FetchCourseLessons({required this.courseId});
  @override
  List<Object?> get props => [courseId];
}

// ==================== COURSE CRUD ====================

class CreateCourse extends CoursesEvent {
  final String title;
  final String description;
  final double price;
  final int sportTypeId;
  final File? thumbnailFile;

  const CreateCourse({
    required this.title,
    required this.description,
    required this.price,
    required this.sportTypeId,
    this.thumbnailFile,
  });

  @override
  List<Object?> get props =>
      [title, description, price, sportTypeId, thumbnailFile];
}

class UpdateCourse extends CoursesEvent {
  final String courseId;
  final String title;
  final String description;
  final double price;
  final int sportTypeId;
  final dynamic thumbnail;

  const UpdateCourse({
    required this.courseId,
    required this.title,
    required this.description,
    required this.price,
    required this.sportTypeId,
    required this.thumbnail,
  });

  @override
  List<Object?> get props =>
      [courseId, title, description, price, sportTypeId, thumbnail];
}

class DeleteCourse extends CoursesEvent {
  final String courseId;
  const DeleteCourse({required this.courseId});
  @override
  List<Object?> get props => [courseId];
}

// ==================== LESSON CRUD ====================

class CreateLesson extends CoursesEvent {
  final String courseId;
  final String title;
  final String description;
  final double duration;
  final File videoFile;
  final int? order;

  const CreateLesson({
    required this.courseId,
    required this.title,
    required this.description,
    required this.duration,
    required this.videoFile,
    this.order,
  });

  @override
  List<Object?> get props =>
      [courseId, title, description, duration, videoFile, order];
}

class UpdateLesson extends CoursesEvent {
  final String lessonId;
  final String title;
  final String description;
  final double duration;
  final int order;
  final dynamic video;

  const UpdateLesson({
    required this.lessonId,
    required this.title,
    required this.description,
    required this.duration,
    required this.order,
    required this.video,
  });

  @override
  List<Object?> get props =>
      [lessonId, title, description, duration, order, video];
}

class DeleteLesson extends CoursesEvent {
  final String lessonId;
  const DeleteLesson({required this.lessonId});
  @override
  List<Object?> get props => [lessonId];
}

// ==================== ENROLLMENT ====================

class EnrollInCourse extends CoursesEvent {
  final String courseId;
  const EnrollInCourse({required this.courseId});
  @override
  List<Object?> get props => [courseId];
}

// ==================== PROGRESS ====================

class UpdateLessonProgress extends CoursesEvent {
  final String lessonId;
  final double watchedTime;
  final bool isWatched;
  final double zoomScale;

  const UpdateLessonProgress({
    required this.lessonId,
    required this.watchedTime,
    required this.isWatched,
    this.zoomScale = 0,
  });

  @override
  List<Object?> get props => [lessonId, watchedTime, isWatched, zoomScale];
}

// ==================== ANALYTICS (PROVIDER) ====================

class FetchEnrolledUsers extends CoursesEvent {
  final String courseId;
  const FetchEnrolledUsers({required this.courseId});
  @override
  List<Object?> get props => [courseId];
}

class FetchRevenueReport extends CoursesEvent {
  final String courseId;
  final int? month;
  final int? year;

  const FetchRevenueReport({
    required this.courseId,
    this.month,
    this.year,
  });

  @override
  List<Object?> get props => [courseId, month, year];
}