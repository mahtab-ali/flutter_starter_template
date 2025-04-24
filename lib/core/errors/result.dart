import 'package:dartz/dartz.dart';
import 'exceptions.dart';

/// A Result type that wraps Either from dartz package
/// to provide a standardized way of handling success and failure cases
///
/// Left side represents failure with AppException
/// Right side represents success with the result of type T
typedef Result<T> = Either<AppException, T>;

/// Extension methods for Result type to make it more ergonomic to use
extension ResultExtensions<T> on Result<T> {
  /// Returns true if the result is a success (Right)
  bool get isSuccess => isRight();

  /// Returns true if the result is a failure (Left)
  bool get isFailure => isLeft();

  /// Returns the success value or null if it's a failure
  T? getSuccessOrNull() {
    return fold((failure) => null, (success) => success);
  }

  /// Returns the failure exception or null if it's a success
  AppException? getFailureOrNull() {
    return fold((failure) => failure, (success) => null);
  }

  /// Gets the success value (data) if present, or throws an error
  T get data =>
      fold((_) => throw StateError('Cannot get data from failure'), (r) => r);

  /// Gets the error if present
  AppException get error =>
      fold((l) => l, (_) => throw StateError('Cannot get error from success'));

  /// Executes one of the provided callbacks depending on whether
  /// this is a success or failure
  R when<R>({
    required R Function(AppException failure) onFailure,
    required R Function(T success) onSuccess,
  }) {
    return fold(onFailure, onSuccess);
  }

  /// Maps the success value to a new type while preserving the Result wrapper
  Result<R> mapSuccess<R>(R Function(T success) mapper) {
    return fold(
      (failure) => Left(failure),
      (success) => Right(mapper(success)),
    );
  }

  /// Transforms the Result into another Result using the provided function
  /// if this is a success, otherwise returns the original failure
  Result<R> flatMap<R>(Result<R> Function(T success) mapper) {
    return fold((failure) => Left(failure), (success) => mapper(success));
  }

  /// Executes the provided callback if this is a success
  Result<T> doOnSuccess(void Function(T success) action) {
    return fold((failure) => Left(failure), (success) {
      action(success);
      return Right(success);
    });
  }

  /// Executes the provided callback if this is a failure
  Result<T> doOnFailure(void Function(AppException failure) action) {
    return fold((failure) {
      action(failure);
      return Left(failure);
    }, (success) => Right(success));
  }
}

/// Helper functions for creating Result instances
class Results {
  /// Creates a Result representing a success with the provided value
  static Result<T> success<T>(T value) => Right(value);

  /// Creates a Result representing a failure with the provided exception
  static Result<T> failure<T>(AppException exception) => Left(exception);

  /// Creates a Result from a function that might throw an AppException
  /// If the function throws, wraps the exception in a Result.failure
  /// Otherwise, wraps the result in a Result.success
  static Result<T> guard<T>(T Function() function) {
    try {
      return success(function());
    } on AppException catch (e) {
      return failure(e);
    } catch (e) {
      return failure(AppException.fromError(e.toString()));
    }
  }

  /// Creates a Result from a Future that might throw an AppException
  /// If the future throws, wraps the exception in a Result.failure
  /// Otherwise, wraps the result in a Result.success
  static Future<Result<T>> guardFuture<T>(Future<T> Function() future) async {
    try {
      return success(await future());
    } on AppException catch (e) {
      return failure(e);
    } catch (e) {
      return failure(AppException.fromError(e.toString()));
    }
  }
}
