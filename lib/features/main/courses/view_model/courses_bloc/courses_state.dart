part of 'courses_bloc.dart';

abstract class CoursesState extends Equatable {
  const CoursesState();
  
  @override
  List<Object?> get props => [];
}

class CoursesInitial extends CoursesState {
  const CoursesInitial();
}

// Loading states
class CoursesLoading extends CoursesState {
  const CoursesLoading();
}

class CourseDetailLoading extends CoursesState {
  const CourseDetailLoading();
}

class EnrollmentLoading extends CoursesState {
  const EnrollmentLoading();
}

class LessonActionLoading extends CoursesState {
  const LessonActionLoading();
}

class CourseActionLoading extends CoursesState {
  const CourseActionLoading();

  @override
  List<Object?> get props => [];
}

// Success states - Browse & List
class CoursesLoaded extends CoursesState {
  final List<CourseModel> courses;
  final bool hasMore;
  final int currentPage;

  const CoursesLoaded({
    required this.courses,
    required this.hasMore,
    required this.currentPage,
  });

  @override
  List<Object> get props => [courses, hasMore, currentPage];
}

class EnrolledCoursesLoaded extends CoursesState {
  final List<CourseModel> courses;
  final bool hasMore;
  final int currentPage;

  const EnrolledCoursesLoaded({
    required this.courses,
    this.hasMore = false,
    this.currentPage = 1,
  });

  @override
  List<Object> get props => [courses, hasMore, currentPage];
}

class MyCoursesLoaded extends CoursesState {
  final List<CourseModel> courses;
  final bool hasMore;
  final int currentPage;

  const MyCoursesLoaded({
    required this.courses,
    this.hasMore = false,
    this.currentPage = 1,
  });

  @override
  List<Object> get props => [courses, hasMore, currentPage];
}

// Success states - Course Detail
class CourseDetailLoaded extends CoursesState {
  final CourseModel course;

  const CourseDetailLoaded({required this.course});

  @override
  List<Object> get props => [course];
}

class LessonsLoaded extends CoursesState {
  final List<LessonModel> lessons;
  final bool isEnrolled;

  const LessonsLoaded({
    required this.lessons,
    required this.isEnrolled,
  });

  @override
  List<Object> get props => [lessons, isEnrolled];
}

// Success states - Enrollment
class EnrollmentSuccess extends CoursesState {
  final String courseId;
  final String message;

  const EnrollmentSuccess({
    required this.courseId,
    this.message = 'Successfully enrolled in course',
  });

  @override
  List<Object> get props => [courseId, message];
}

// Success states - Progress
class ProgressUpdated extends CoursesState {
  final String lessonId;
  final bool isWatched;

  const ProgressUpdated({
    required this.lessonId,
    required this.isWatched,
  });

  @override
  List<Object> get props => [lessonId, isWatched];
}

// Success states - Provider Actions
class CourseCreated extends CoursesState {
  final CourseModel course;

  const CourseCreated({required this.course});

  @override
  List<Object> get props => [course];
}

class CourseUpdated extends CoursesState {
  final CourseModel course;

  const CourseUpdated({required this.course});

  @override
  List<Object?> get props => [course];
}

class CourseDeleted extends CoursesState {
  final String courseId;

  const CourseDeleted({required this.courseId});

  @override
  List<Object> get props => [courseId];
}

class LessonCreated extends CoursesState {
  final LessonModel lesson;

  const LessonCreated({required this.lesson});

  @override
  List<Object> get props => [lesson];
}

class LessonUpdated extends CoursesState {
  final LessonModel lesson;

  const LessonUpdated({required this.lesson});

  @override
  List<Object?> get props => [lesson];
}

class LessonDeleted extends CoursesState {
  final String lessonId;

  const LessonDeleted({required this.lessonId});

  @override
  List<Object?> get props => [lessonId];
}

// Success states - Analytics
class EnrolleesLoaded extends CoursesState {
  final List<EnrolledUserModel> enrollees;

  const EnrolleesLoaded({required this.enrollees});

  @override
  List<Object> get props => [enrollees];
}

class RevenueReportLoaded extends CoursesState {
  final RevenueReportModel report; 

  const RevenueReportLoaded({required this.report});

  @override
  List<Object> get props => [report];
}

// Error states
class CoursesError extends CoursesState {
  final String message;

  const CoursesError({required this.message});

  @override
  List<Object> get props => [message];
}