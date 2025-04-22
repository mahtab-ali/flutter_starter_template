import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

// Event to check if onboarding is completed
class OnboardingCheckRequested extends OnboardingEvent {}

// Event when user completes onboarding
class OnboardingCompleted extends OnboardingEvent {}

// Event when user navigates between onboarding pages
class OnboardingPageChanged extends OnboardingEvent {
  final int pageIndex;

  const OnboardingPageChanged({required this.pageIndex});

  @override
  List<Object?> get props => [pageIndex];
}
