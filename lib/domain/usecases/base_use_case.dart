import '../../core/errors/result.dart';

/// Base interface for use cases that take a parameter and return a result
abstract class UseCase<Type, Params> {
  /// Execute the use case with the given parameters
  Future<Result<Type>> call(Params params);
}

/// Base interface for use cases that don't take any parameters but return a result
abstract class UseCaseNoParams<Type> {
  /// Execute the use case
  Future<Result<Type>> call();
}

/// Class representing that no parameters are required for a use case
class NoParams {
  const NoParams();
}
