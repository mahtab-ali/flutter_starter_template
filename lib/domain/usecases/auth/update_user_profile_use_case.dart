import '../../../core/errors/result.dart';
import '../../repositories/auth_repository.dart';
import '../base_use_case.dart';

/// Parameters for update user profile use case
class UpdateUserProfileParams {
  final String? displayName;

  const UpdateUserProfileParams({this.displayName});
}

/// Use case for updating user profile data
class UpdateUserProfileUseCase
    implements UseCase<UserEntity, UpdateUserProfileParams> {
  final AuthRepository repository;

  UpdateUserProfileUseCase(this.repository);

  @override
  Future<Result<UserEntity>> call(UpdateUserProfileParams params) async {
    return await repository.updateUserProfile(displayName: params.displayName);
  }
}
