import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/onboarding_preferences.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  // The total number of onboarding pages
  static const int totalPages = 3;

  OnboardingBloc() : super(OnboardingInitial()) {
    on<OnboardingCheckRequested>(_onOnboardingCheckRequested);
    on<OnboardingCompleted>(_onOnboardingCompleted);
    on<OnboardingPageChanged>(_onOnboardingPageChanged);
  }

  void _onOnboardingCheckRequested(
    OnboardingCheckRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    final bool isCompleted =
        await OnboardingPreferences.isOnboardingCompleted();

    if (isCompleted) {
      emit(OnboardingFinished());
    } else {
      emit(const OnboardingInProgress(currentPage: 0, totalPages: totalPages));
    }
  }

  void _onOnboardingCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) async {
    await OnboardingPreferences.setOnboardingCompleted(true);
    emit(OnboardingFinished());
  }

  void _onOnboardingPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingInProgress) {
      emit(
        OnboardingInProgress(
          currentPage: event.pageIndex,
          totalPages: totalPages,
        ),
      );
    }
  }
}
