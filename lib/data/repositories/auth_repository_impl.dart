import '../../core/errors/result.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import 'base_repository.dart';

/// Implementation of [AuthRepository]
class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  /// Create a new instance with the required dependencies
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required NetworkInfo networkInfo,
  }) : super(networkInfo);

  @override
  Future<Result<UserEntity?>> getCurrentUser() async {
    return safeApiCall(() => remoteDataSource.getCurrentUser());
  }

  @override
  Future<Result<bool>> isAuthenticated() async {
    return safeApiCall(() => remoteDataSource.isAuthenticated());
  }

  @override
  Future<Result<void>> sendPasswordResetEmail(String email) async {
    return safeApiCall(() => remoteDataSource.sendPasswordResetEmail(email));
  }

  @override
  Future<Result<UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return safeApiCall(
      () => remoteDataSource.signInWithEmail(email: email, password: password),
    );
  }

  @override
  Future<Result<void>> signOut() async {
    return safeApiCall(() => remoteDataSource.signOut());
  }

  @override
  Future<Result<UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    return safeApiCall(
      () => remoteDataSource.signUpWithEmail(
        email: email,
        password: password,
        name: name,
      ),
    );
  }

  @override
  Future<Result<UserEntity>> updateUserProfile({String? displayName}) async {
    return safeApiCall(
      () => remoteDataSource.updateUserProfile(displayName: displayName),
    );
  }
}
