import '../../../core/errors/result.dart';
import '../../repositories/auth_repository.dart';
import '../base_use_case.dart';

/// Parameters for sign in use case
class SignInParams {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});
}

/// Use case for user sign in with email and password
class SignInUseCase implements UseCase<UserEntity, SignInParams> {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  @override
  Future<Result<UserEntity>> call(SignInParams params) async {
    return await repository.signInWithEmail(
      email: params.email,
      password: params.password,
    );
  }
}
