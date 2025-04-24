import '../../../core/errors/result.dart';
import '../../repositories/auth_repository.dart';
import '../base_use_case.dart';

/// Use case to check if the user is currently authenticated
class CheckAuthStatusUseCase implements UseCaseNoParams<bool> {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  @override
  Future<Result<bool>> call() async {
    return await repository.isAuthenticated();
  }
}
