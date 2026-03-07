import 'dart:async';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../data/repo/course_repository.dart';
import '../../model/course_models.dart';

part 'courses_event.dart';
part 'courses_state.dart';

@injectable
class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final CourseRepository _repository;

  // Cache for pagination
  final List<CourseModel> _availableCourses = [];
  final List<CourseModel> _enrolledCourses = [];
  final List<CourseModel> _createdCourses = [];

  CoursesBloc(this._repository) : super(const CoursesInitial()) {
    on<FetchAvailableCourses>(_onFetchAvailableCourses);
    on<FetchEnrolledCourses>(_onFetchEnrolledCourses);
    on<FetchCreatedCourses>(_onFetchCreatedCourses);
    on<FetchCourseDetail>(_onFetchCourseDetail);
    on<FetchCourseLessons>(_onFetchCourseLessons);
    on<CreateCourse>(_onCreateCourse);
    on<UpdateCourse>(_onUpdateCourse);
    on<DeleteCourse>(_onDeleteCourse);
    on<CreateLesson>(_onCreateLesson);
    on<UpdateLesson>(_onUpdateLesson);
    on<DeleteLesson>(_onDeleteLesson);
    on<EnrollInCourse>(_onEnrollInCourse);
    on<UpdateLessonProgress>(_onUpdateLessonProgress);
    on<FetchEnrolledUsers>(_onFetchEnrolledUsers);
    on<FetchRevenueReport>(_onFetchRevenueReport);
  }

  // ==================== BROWSE & DISCOVERY ====================

  Future<void> _onFetchAvailableCourses(
    FetchAvailableCourses event,
    Emitter<CoursesState> emit,
  ) async {
    try {
      if (event.isRefresh || event.page == 1) {
        emit(const CoursesLoading());
        _availableCourses.clear();
      }

      final response = await _repository.getAvailableCourses(
        searchTerm: event.searchTerm,
        sportTypeId: event.sportTypeId,
        page: event.page,
        size: event.size,
      );

      _availableCourses.addAll(response.items);

      emit(CoursesLoaded(
        courses: List.from(_availableCourses),
        hasMore: response.hasNextPage,
        currentPage: response.pageNumber,
      ));
    } catch (e) {
      debugPrint('Error fetching available courses: $e');
      emit(CoursesError(message: e.toString()));
    }
  }

  Future<void> _onFetchEnrolledCourses(
    FetchEnrolledCourses event,
    Emitter<CoursesState> emit,
  ) async {
    try {
      if (event.isRefresh || event.page == 1) {
        emit(const CoursesLoading());
        _enrolledCourses.clear();
      }

      final response = await _repository.getEnrolledCourses(
        searchTerm: event.searchTerm,
        sportTypeId: event.sportTypeId,
        page: event.page,
        size: event.size,
      );

      _enrolledCourses.addAll(response.items);

      emit(EnrolledCoursesLoaded(
        courses: List.from(_enrolledCourses),
        hasMore: response.hasNextPage,
        currentPage: response.pageNumber,
      ));
    } catch (e) {
      debugPrint('Error fetching enrolled courses: $e');
      emit(CoursesError(message: e.toString()));
    }
  }

  Future<void> _onFetchCreatedCourses(
    FetchCreatedCourses event,
    Emitter<CoursesState> emit,
  ) async {
    try {
      if (event.isRefresh || event.page == 1) {
        emit(const CoursesLoading());
        _createdCourses.clear();
      }

      final response = await _repository.getCreatedCourses(
        searchTerm: event.searchTerm,
        sportTypeId: event.sportTypeId,
        page: event.page,
        size: event.size,
      );

      _createdCourses.addAll(response.items);

      emit(MyCoursesLoaded(
        courses: List.from(_createdCourses),
        hasMore: response.hasNextPage,
        currentPage: response.pageNumber,
      ));
    } catch (e) {
      debugPrint('Error fetching created courses: $e');
      emit(CoursesError(message: e.toString()));
    }
  }

  // ==================== COURSE DETAIL ====================

  Future<void> _onFetchCourseDetail(
    FetchCourseDetail event,
    Emitter<CoursesState> emit,
  ) async {
    try {
      emit(const CourseDetailLoading());

      final course = await _repository.getCourseById(event.courseId);

      emit(CourseDetailLoaded(course: course));
    } catch (e) {
      debugPrint('Error fetching course detail: $e');
      emit(CoursesError(message: e.toString()));
    }
  }

Future<void> _onFetchCourseLessons(
  FetchCourseLessons event,
  Emitter<CoursesState> emit,
) async {
  try {
    final lessons = await _repository.getCourseLessons(event.courseId);
    final course = await _repository.getCourseById(event.courseId);
    emit(LessonsLoaded(
      lessons: lessons,
      courseId: event.courseId,
      isEnrolled: course.isEnrolled,
    ));
  } catch (e) {
    emit(CoursesError(message: e.toString()));
  }
}
  // ==================== COURSE CRUD ====================

  Future<void> _onCreateCourse(
    CreateCourse event,
    Emitter<CoursesState> emit,
  ) async {
    try {
      emit(const CourseActionLoading());

      final request = CreateCourseRequest(
        title: event.title,
        description: event.description,
        price: event.price,
        sportTypeId: event.sportTypeId,
        thumbnailFile: event.thumbnailFile,
      );

      final course = await _repository.createCourse(request);

      emit(CourseCreated(course: course));
    } catch (e) {
      debugPrint('Error creating course: $e');
      emit(CoursesError(message: e.toString()));
    }
  }

  Future<void> _onUpdateCourse(
  UpdateCourse event,
  Emitter<CoursesState> emit,
) async {
  try {
    emit(const CourseActionLoading());
    
    final course = await _repository.updateCourse(
      UpdateCourseRequest(
        id: event.courseId,
        title: event.title,
        description: event.description,
        price: event.price,
        sportTypeId: event.sportTypeId,
        thumbnail: event.thumbnail,
      ),
    );
    
    emit(CourseUpdated(course: course));
    
    // Refresh course details
    add(FetchCourseDetail(courseId: event.courseId));
  } catch (e) {
    emit(CoursesError(message: e.toString()));
  }
}

  Future<void> _onDeleteCourse(
    DeleteCourse event,
    Emitter<CoursesState> emit,
  ) async {
    try {
      emit(const CourseActionLoading());

      await _repository.deleteCourse(event.courseId);

      // Remove from cache
      _createdCourses.removeWhere((c) => c.id == event.courseId);

      emit(CourseDeleted(courseId: event.courseId));
    } catch (e) {
      debugPrint('Error deleting course: $e');
      emit(CoursesError(message: e.toString()));
    }
  }

  // ==================== LESSON CRUD ====================

  Future<void> _onCreateLesson(
    CreateLesson event,
    Emitter<CoursesState> emit,
  ) async {
    try {
      emit(const LessonActionLoading());

      // Get current lessons to calculate order
      final lessons = await _repository.getCourseLessons(event.courseId);
      final order = event.order ?? (lessons.length + 1);

      final request = CreateLessonRequest(
        title: event.title,
        description: event.description,
        duration: event.duration,
        order: order,
        videoFile: event.videoFile,
      );

      final lesson = await _repository.createLesson(
        courseId: event.courseId,
        request: request,
      );

      emit(LessonCreated(lesson: lesson));
    } catch (e) {
      debugPrint('Error creating lesson: $e');
      emit(CoursesError(message: e.toString()));
    }
  }

  Future<void> _onUpdateLesson(
  UpdateLesson event,
  Emitter<CoursesState> emit,
) async {
  try {
    emit(const CourseActionLoading());
    
    final lesson = await _repository.updateLesson(
      UpdateLessonRequest(lessonId: event.lessonId,
      title: event.title,
      description: event.description,
      duration: event.duration,
      order: event.order,
      video: event.video,
      )
    );
    
    emit(LessonUpdated(lesson: lesson));
    
    // Note: You may want to refresh lessons here
    // add(FetchCourseLessons(courseId: ...));
  } catch (e) {
    emit(CoursesError(message: e.toString()));
  }
}


  Future<void> _onDeleteLesson(
    DeleteLesson event,
    Emitter<CoursesState> emit,
  ) async {
    try {
      emit(const CourseActionLoading());
      
      await _repository.deleteLesson(event.lessonId);
      
      emit(LessonDeleted(lessonId: event.lessonId));
    } catch (e) {
      debugPrint('Error deleting lesson: $e');
      emit(CoursesError(message: e.toString()));
    }
  }

  // ==================== ENROLLMENT ====================

  Future<void> _onEnrollInCourse(
    EnrollInCourse event,
    Emitter<CoursesState> emit,
  ) async {
    try {
      emit(const EnrollmentLoading());

      await _repository.enrollInCourse(event.courseId);

      emit(EnrollmentSuccess(courseId: event.courseId));
    } catch (e) {
      debugPrint('Error enrolling in course: $e');
      emit(CoursesError(message: e.toString()));
    }
  }


//  ==================== PROGRESS ====================

  Future<void> _onUpdateLessonProgress(
    UpdateLessonProgress event,
    Emitter<CoursesState> emit,
  ) async {
    try {
      final request = UpdateProgressRequest(
        watchedTime: event.watchedTime,
        isWatched: event.isWatched,
        zoomScale: event.zoomScale,
      );

      await _repository.updateLessonProgress(
        lessonId: event.lessonId,
        request: request,
      );
      
    } catch (e) {
      debugPrint('Error updating progress: $e');
      emit(CoursesError(message: e.toString()));}
  }
  // ==================== ANALYTICS (PROVIDER) ====================

  Future<void> _onFetchEnrolledUsers(
    FetchEnrolledUsers event,
    Emitter<CoursesState> emit,
  ) async {
    try {
      emit(const CoursesLoading());

      final enrollees = await _repository.getEnrolledUsers(event.courseId);

      emit(EnrolleesLoaded(enrollees: enrollees));
    } catch (e) {
      debugPrint('Error fetching enrolled users: $e');
      emit(CoursesError(message: e.toString()));
    }
  }

  Future<void> _onFetchRevenueReport(
    FetchRevenueReport event,
    Emitter<CoursesState> emit,
  ) async {
    try {
      emit(const CoursesLoading());

      final report = await _repository.getRevenueReport(
        courseId: event.courseId,
        month: event.month,
        year: event.year,
      );

      emit(RevenueReportLoaded(report: report));
    } catch (e) {
      debugPrint('Error fetching revenue report: $e');
      emit(CoursesError(message: e.toString()));
    }
  }
}