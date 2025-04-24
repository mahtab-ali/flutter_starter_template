import '../../../core/errors/result.dart';
import '../../repositories/auth_repository.dart';
import '../base_use_case.dart';

/// Use case for getting the current authenticated user
class GetCurrentUserUseCase implements UseCaseNoParams<UserEntity?> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Result<UserEntity?>> call() async {
    return await repository.getCurrentUser();
  }
}
