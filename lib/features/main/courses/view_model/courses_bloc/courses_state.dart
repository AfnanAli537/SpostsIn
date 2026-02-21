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

// Success states
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

  const EnrolledCoursesLoaded({required this.courses});

  @override
  List<Object> get props => [courses];
}

class MyCoursesLoaded extends CoursesState {
  final List<CourseModel> courses;
  final bool isOwner;

  const MyCoursesLoaded({
    required this.courses,
    required this.isOwner,
  });

  @override
  List<Object> get props => [courses, isOwner];
}

class CourseDetailLoaded extends CoursesState {
  final CourseModel course;

  const CourseDetailLoaded({required this.course});

  @override
  List<Object> get props => [course];
}

class LessonsLoaded extends CoursesState {
  final List<LessonModel> lessons;
  final bool isEnrolled;
  final bool hasMore;

  const LessonsLoaded({
    required this.lessons,
    required this.isEnrolled,
    required this.hasMore,
  });

  @override
  List<Object> get props => [lessons, isEnrolled, hasMore];
}

class EnrollmentSuccess extends CoursesState {
  final String courseId;

  const EnrollmentSuccess({required this.courseId});

  @override
  List<Object> get props => [courseId];
}

class ProgressUpdated extends CoursesState {
  final String lessonId;
  final bool isWatched;
  final int progressPercent;

  const ProgressUpdated({
    required this.lessonId,
    required this.isWatched,
    required this.progressPercent,
  });

  @override
  List<Object> get props => [lessonId, isWatched, progressPercent];
}

class CourseCreated extends CoursesState {
  final CourseModel course;

  const CourseCreated({required this.course});

  @override
  List<Object> get props => [course];
}

class VideoUploaded extends CoursesState {
  final LessonModel lesson;

  const VideoUploaded({required this.lesson});

  @override
  List<Object> get props => [lesson];
}

class EnrolleesLoaded extends CoursesState {
  final List<EnrolleeModel> enrollees;
  final int totalEnrolled;

  const EnrolleesLoaded({
    required this.enrollees,
    required this.totalEnrolled,
  });

  @override
  List<Object> get props => [enrollees, totalEnrolled];
}

class RevenueTimelineLoaded extends CoursesState {
  final RevenueTimelineModel data;

  const RevenueTimelineLoaded({required this.data});

  @override
  List<Object> get props => [data];
}

// Error states
class CoursesError extends CoursesState {
  final String message;

  const CoursesError({required this.message});

  @override
  List<Object> get props => [message];
}