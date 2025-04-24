import '../../../core/errors/result.dart';
import '../../repositories/auth_repository.dart';
import '../base_use_case.dart';

/// Parameters for sign up use case
class SignUpParams {
  final String email;
  final String password;
  final String? name;

  const SignUpParams({required this.email, required this.password, this.name});
}

/// Use case for user sign up with email and password
class SignUpUseCase implements UseCase<UserEntity, SignUpParams> {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  @override
  Future<Result<UserEntity>> call(SignUpParams params) async {
    return await repository.signUpWithEmail(
      email: params.email,
      password: params.password,
      name: params.name,
    );
  }
}
