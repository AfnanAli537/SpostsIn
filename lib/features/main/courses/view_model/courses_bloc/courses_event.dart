part of 'courses_bloc.dart';

abstract class CoursesEvent extends Equatable {
  const CoursesEvent();

  @override
  List<Object> get props => [];
}
// Browse & Search
class FetchCourses extends CoursesEvent {
  final String? search;
  final String? sport;
  final String? level;
  final int page;

  const FetchCourses({
    this.search,
    this.sport,
    this.level,
    required this.page,
  });

  @override
  List<Object> get props => [search ?? '', sport ?? '', level ?? '', page];
}

class FetchEnrolledCourses extends CoursesEvent {
  const FetchEnrolledCourses();
}

class FetchMyCourses extends CoursesEvent {
  final String userId;

  const FetchMyCourses({required this.userId});

  @override
  List<Object> get props => [userId];
}

// Course Detail
class FetchCourseDetail extends CoursesEvent {
  final String courseId;

  const FetchCourseDetail({required this.courseId});

  @override
  List<Object> get props => [courseId];
}

class FetchLessons extends CoursesEvent {
  final String courseId;
  final int page;

  const FetchLessons({required this.courseId, required this.page});

  @override
  List<Object> get props => [courseId, page];
}

// Enrollment
class EnrollInCourse extends CoursesEvent {
  final String courseId;
  final String? paymentMethodId;

  const EnrollInCourse({
    required this.courseId,
    this.paymentMethodId,
  });

  @override
  List<Object> get props => [courseId, paymentMethodId ?? ''];
}

// Progress
class UpdateLessonProgress extends CoursesEvent {
  final String courseId;
  final String lessonId;
  final int watchedDurationSeconds;

  const UpdateLessonProgress({
    required this.courseId,
    required this.lessonId,
    required this.watchedDurationSeconds,
  });

  @override
  List<Object> get props => [courseId, lessonId, watchedDurationSeconds];
}

// Provider
class CreateCourse extends CoursesEvent {
  final String title;
  final String sport;
  final String level;
  final double price;
  final String description;
  final File thumbnailFile;

  const CreateCourse({
    required this.title,
    required this.sport,
    required this.level,
    required this.price,
    required this.description,
    required this.thumbnailFile,
  });

  @override
  List<Object> get props => [title, sport, level, price, description, thumbnailFile];
}

class UploadVideo extends CoursesEvent {
  final String courseId;
  final String title;
  final int order;
  final File videoFile;

  const UploadVideo({
    required this.courseId,
    required this.title,
    required this.order,
    required this.videoFile,
  });

  @override
  List<Object> get props => [courseId, title, order, videoFile];
}

class FetchEnrollees extends CoursesEvent {
  final String courseId;
  final int page;

  const FetchEnrollees({required this.courseId, required this.page});

  @override
  List<Object> get props => [courseId, page];
}

class FetchRevenueTimeline extends CoursesEvent {
  final String courseId;
  final String period; // week, month, year

  const FetchRevenueTimeline({
    required this.courseId,
    required this.period,
  });

  @override
  List<Object> get props => [courseId, period];
}