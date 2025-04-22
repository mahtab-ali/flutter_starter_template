import 'package:equatable/equatable.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

// Initial state before checking if onboarding is needed
class OnboardingInitial extends OnboardingState {}

// State indicating onboarding is needed and which page is currently active
class OnboardingInProgress extends OnboardingState {
  final int currentPage;
  final int totalPages;

  const OnboardingInProgress({
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [currentPage, totalPages];
}

// State indicating onboarding has been completed
class OnboardingFinished extends OnboardingState {}
