import 'package:dartz/dartz.dart';

import '../../../core/errors/exceptions.dart';

/// Abstract base class for all use cases.
/// Type parameters:
/// * [T]: The success type returned by the use case
/// * [Params]: The parameters type required by the use case
abstract class BaseUseCase<T, Params> {
  /// Execute the use case with the given parameters, returning either an error or a result
  Future<Either<AppException, T>> call(Params params);
}

/// NoParams class for use cases that don't require any parameters
class NoParams {
  const NoParams();
}
