import '../../../core/errors/result.dart';
import '../../repositories/auth_repository.dart';
import '../base_use_case.dart';

/// Use case for user sign out
class SignOutUseCase implements UseCaseNoParams<void> {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  @override
  Future<Result<void>> call() async {
    return await repository.signOut();
  }
}
