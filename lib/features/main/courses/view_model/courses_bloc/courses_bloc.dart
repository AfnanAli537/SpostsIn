import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sports_in/features/main/courses/model/course_models.dart';

part 'courses_event.dart';
part 'courses_state.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  CoursesBloc() : super(CoursesInitial());

  @override
  Stream<CoursesState> mapEventToState(
    CoursesEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
