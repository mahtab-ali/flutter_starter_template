import '../../core/errors/result.dart';

/// Interface for onboarding operations
abstract class OnboardingRepository {
  /// Check if onboarding has been completed
  Future<Result<bool>> isOnboardingCompleted();

  /// Set onboarding as completed
  Future<Result<void>> setOnboardingCompleted(bool completed);
}
