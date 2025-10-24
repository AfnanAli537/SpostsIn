import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sports_in/core/constants/assets_manager.dart';
import 'package:sports_in/core/constants/strings_manager.dart';
import '../../data/models/onboarding_model.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingLoading()) {
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
        title: StringsManager.onboarding1Title,
        description: StringsManager.onboarding1desc,
        imagePath:ImageAssets.onboarding1 ,
      ),
      OnboardingModel(
        title: StringsManager.onboarding2Title,
        description: StringsManager.onboarding2desc,
        imagePath:ImageAssets.onboarding2,
      ),
      OnboardingModel(
        title:StringsManager.onboarding3Title ,
        description:StringsManager.onboarding3desc ,
        imagePath:ImageAssets.onboarding3 ,
      ),
      OnboardingModel(
        title:StringsManager.onboarding4Title,
        description:StringsManager.onboarding4desc ,
        imagePath:ImageAssets.onboarding4 ,
      ),
      OnboardingModel(
        title:StringsManager.onboarding5Title ,
        description:StringsManager.onboarding5desc ,
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

  void _onSkip(SkipEvent event, Emitter<OnboardingState> emit) {
    if (state is OnboardingLoaded) {
      final s = state as OnboardingLoaded;
      emit(s.copyWith(currentPageIndex: s.pages.length - 1));
    }
  }

 void _onChangePage(ChangePageEvent event, Emitter<OnboardingState> emit) {
    if (state is OnboardingLoaded) {
      final s = state as OnboardingLoaded;
      emit(s.copyWith(currentPageIndex: event.newIndex));
    }
 }
  void _onComplete(CompleteOnboardingEvent event, Emitter<OnboardingState> emit) {
    emit(OnboardingCompleted());
  }

}
