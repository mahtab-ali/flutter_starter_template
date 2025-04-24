import '../../core/errors/exceptions.dart';
import '../../core/errors/result.dart';
import '../../core/network/network_info.dart';

/// Base repository class with common functionality
abstract class BaseRepository {
  final NetworkInfo networkInfo;

  /// Constructor requires NetworkInfo for connectivity checking
  const BaseRepository(this.networkInfo);

  /// Execute a data source function with error handling and connectivity check
  Future<Result<T>> safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return Results.failure(
          const NetworkException('No internet connection'),
        );
      }

      final result = await apiCall();
      return Results.success(result);
    } on AppException catch (e) {
      return Results.failure(e);
    } catch (e) {
      return Results.failure(
        ServerException(e.toString(), code: 'unknown_error'),
      );
    }
  }

  /// Execute a local data source function with error handling
  Future<Result<T>> safeLocalCall<T>(Future<T> Function() localCall) async {
    try {
      final result = await localCall();
      return Results.success(result);
    } on CacheException catch (e) {
      return Results.failure(e);
    } catch (e) {
      return Results.failure(
        CacheException(e.toString(), code: 'local_storage_error'),
      );
    }
  }
}
