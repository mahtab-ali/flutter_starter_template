import '../../../core/errors/result.dart';
import '../../repositories/onboarding_repository.dart';
import '../base_use_case.dart';

/// Use case for checking the onboarding completion status
class CheckOnboardingStatusUseCase implements UseCaseNoParams<bool> {
  final OnboardingRepository repository;

  CheckOnboardingStatusUseCase(this.repository);

  @override
  Future<Result<bool>> call() async {
    return await repository.isOnboardingCompleted();
  }
}
