import '../../../domain/repositories/auth_repository.dart';

/// Interface for authentication remote operations
abstract class AuthRemoteDataSource {
  /// Get the current user if authenticated
  Future<UserEntity?> getCurrentUser();

  /// Sign in with email and password
  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  Future<UserEntity> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  });

  /// Sign out the current user
  Future<void> signOut();

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email);

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Update user profile data
  Future<UserEntity> updateUserProfile({String? displayName});
}
