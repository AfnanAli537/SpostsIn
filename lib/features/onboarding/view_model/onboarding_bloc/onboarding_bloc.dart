import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_in/app/di/injection.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';


part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
 final sharedPref = getIt<SharedPref>();
  OnboardingBloc() : super(OnboardingLoading()) {
    on<LoadOnboardingEvent>(_onLoad );
    on<NextPageEvent>(_onNext);
    on<PreviousPageEvent>(_onPrevious);
    on<SkipEvent>(_onSkip);
    on<ChangePageEvent>(_onChangePage);
    on<CompleteOnboardingEvent>(_onComplete);
  }

  void _onLoad(LoadOnboardingEvent event, Emitter<OnboardingState> emit) {
  emit(OnboardingLoaded(currentPageIndex: 0, pagesLength: event.pagesLength));
}

  void _onNext(NextPageEvent event, Emitter<OnboardingState> emit) {
    if (state is OnboardingLoaded) {
      final s = state as OnboardingLoaded;
      if (s.currentPageIndex < s.pagesLength - 1) {
        emit(s.copyWith(currentPageIndex: s.currentPageIndex + 1));
      } else {
        emit(OnboardingCompleted());
      }
    }
  }

  void _onPrevious(PreviousPageEvent event, Emitter<OnboardingState> emit) {
    if (state is OnboardingLoaded) {
      final s = state as OnboardingLoaded;
      if (s.currentPageIndex > 0) {
        emit(s.copyWith(currentPageIndex: s.currentPageIndex - 1));
      }
    }
  }

  void _onSkip(SkipEvent event, Emitter<OnboardingState> emit)async {
    if (state is OnboardingLoaded) {
      await sharedPref.setOnboardingCompleted(true);
      emit(OnboardingCompleted());
      
    }
  }

 void _onChangePage(ChangePageEvent event, Emitter<OnboardingState> emit) {
    if (state is OnboardingLoaded) {
      final s = state as OnboardingLoaded;
      emit(s.copyWith(currentPageIndex: event.newIndex));
    }
 }
  void _onComplete(CompleteOnboardingEvent event, Emitter<OnboardingState> emit)async {
    await sharedPref.setOnboardingCompleted(true);
    emit(OnboardingCompleted());
  }

}
