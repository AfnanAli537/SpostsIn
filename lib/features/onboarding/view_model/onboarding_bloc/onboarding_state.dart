part of 'onboarding_bloc.dart';

@immutable
sealed class OnboardingState {}

final class OnboardingLoading extends OnboardingState {}

final class OnboardingLoaded extends OnboardingState {
  final int currentPageIndex;
  final int  pagesLength;
  OnboardingLoaded({
    required this.currentPageIndex, required this.pagesLength,
  });

  OnboardingLoaded copyWith({int? currentPageIndex,int? pagesLength }) {
    return OnboardingLoaded(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      pagesLength : pagesLength ?? this.pagesLength,
    );
  }
}

final class OnboardingCompleted extends OnboardingState {}
