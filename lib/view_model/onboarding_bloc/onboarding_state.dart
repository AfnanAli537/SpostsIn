part of 'onboarding_bloc.dart';

@immutable
sealed class OnboardingState {}

final class OnboardingLoading extends OnboardingState {}

final class OnboardingLoaded extends OnboardingState {
  final int currentPageIndex;
  final List<OnboardingModel> pages;

  OnboardingLoaded({
    required this.currentPageIndex,
    required this.pages,
  });

  OnboardingLoaded copyWith({int? currentPageIndex, List<OnboardingModel>? pages}) {
    return OnboardingLoaded(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      pages: pages ?? this.pages,
    );
  }
}

final class OnboardingCompleted extends OnboardingState {}
