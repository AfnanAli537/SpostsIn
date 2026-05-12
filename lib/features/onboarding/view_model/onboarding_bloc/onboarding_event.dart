part of 'onboarding_bloc.dart';

@immutable
sealed class OnboardingEvent {}
class LoadOnboardingEvent extends OnboardingEvent {
  final int pagesLength;

  LoadOnboardingEvent({required this.pagesLength});
}
final class NextPageEvent extends OnboardingEvent {}
final class PreviousPageEvent extends OnboardingEvent {}
final class SkipEvent extends OnboardingEvent {}
final class CompleteOnboardingEvent extends OnboardingEvent {}
class ChangePageEvent extends OnboardingEvent {
  final int newIndex;
  ChangePageEvent(this.newIndex);
}
