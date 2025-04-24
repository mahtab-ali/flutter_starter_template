import '../../core/errors/result.dart';

/// User entity representing the authenticated user
class UserEntity {
  final String id;
  final String? email;
  final String? name;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

  UserEntity({
    required this.id,
    this.email,
    this.name,
    this.metadata,
    this.createdAt,
    this.lastLoginAt,
  });
}

/// Interface for authentication operations
abstract class AuthRepository {
  /// Get the current authenticated user if any
  Future<Result<UserEntity?>> getCurrentUser();

  /// Sign in with email and password
  Future<Result<UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  Future<Result<UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  });

  /// Sign out the current user
  Future<Result<void>> signOut();

  /// Send password reset email
  Future<Result<void>> sendPasswordResetEmail(String email);

  /// Check if user is authenticated
  Future<Result<bool>> isAuthenticated();

  /// Update user profile data
  Future<Result<UserEntity>> updateUserProfile({String? displayName});
}
