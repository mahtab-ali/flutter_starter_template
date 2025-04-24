import '../../../core/errors/result.dart';
import '../../repositories/onboarding_repository.dart';
import '../base_use_case.dart';

/// Use case for completing the onboarding process
class CompleteOnboardingUseCase implements UseCaseNoParams<void> {
  final OnboardingRepository repository;

  CompleteOnboardingUseCase(this.repository);

  @override
  Future<Result<void>> call() async {
    return await repository.setOnboardingCompleted(true);
  }
}
