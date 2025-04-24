import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';
import '../../repositories/auth_repository.dart';
import '../base/base_use_case.dart';

/// Parameters for the reset password use case
class ResetPasswordParams {
  /// Email to reset password for
  final String email;

  /// Constructor
  const ResetPasswordParams({required this.email});
}

/// Use case for resetting a user's password
class ResetPasswordUseCase implements BaseUseCase<bool, ResetPasswordParams> {
  final AuthRepository _repository;

  /// Constructor
  const ResetPasswordUseCase(this._repository);

  @override
  Future<Either<AppException, bool>> call(ResetPasswordParams params) async {
    final result = await _repository.sendPasswordResetEmail(params.email);

    // Convert Result<void> to Either<AppException, bool>
    return result.fold((failure) => Left(failure), (_) => const Right(true));
  }
}
