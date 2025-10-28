import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sports_in/core/cache/shared_pref/shared_pref.dart';
import 'package:sports_in/core/constants/assets_manager.dart';
import 'package:sports_in/core/constants/strings_keys.dart';
import '../../data/models/onboarding_model.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final SharedPref sharedPrefHelper;
  OnboardingBloc(this.sharedPrefHelper) : super(OnboardingLoading()) {
    on<LoadOnboardingEvent>(_onLoad);
    on<NextPageEvent>(_onNext);
    on<PreviousPageEvent>(_onPrevious);
    on<SkipEvent>(_onSkip);
    on<ChangePageEvent>(_onChangePage);
    on<CompleteOnboardingEvent>(_onComplete);
  }

  void _onLoad(LoadOnboardingEvent event, Emitter<OnboardingState> emit) {
    final pages = [
      OnboardingModel(
       title: StringKeys.onboarding1Title,
       description: StringKeys.onboarding1Desc,
        imagePath:ImageAssets.onboarding1 ,
      ),
      OnboardingModel(
        title: StringKeys.onboarding2Title,
        description: StringKeys.onboarding2Desc,
        imagePath:ImageAssets.onboarding2,
      ),
      OnboardingModel(
        title:StringKeys.onboarding3Title ,
        description:StringKeys.onboarding3Desc ,
        imagePath:ImageAssets.onboarding3 ,
      ),
      OnboardingModel(
        title:StringKeys.onboarding4Title,
        description:StringKeys.onboarding4Desc ,
        imagePath:ImageAssets.onboarding4 ,
      ),
      OnboardingModel(
        title:StringKeys.onboarding5Title ,
        description:StringKeys.onboarding5Desc ,
        imagePath:ImageAssets.onboarding5 ,
      ),
    ];

    emit(OnboardingLoaded(currentPageIndex: 0, pages: pages));
  }

  void _onNext(NextPageEvent event, Emitter<OnboardingState> emit) {
    if (state is OnboardingLoaded) {
      final s = state as OnboardingLoaded;
      if (s.currentPageIndex < s.pages.length - 1) {
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
      await sharedPrefHelper.setOnboardingCompleted(true);
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
    await sharedPrefHelper.setOnboardingCompleted(true);
    emit(OnboardingCompleted());
  }

}
