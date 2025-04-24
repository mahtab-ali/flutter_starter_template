import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/errors/exceptions.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_remote_datasource.dart';

/// Implementation of [AuthRemoteDataSource] using Supabase
class SupabaseAuthRemoteDataSource implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  /// Create a new instance with the provided [SupabaseClient]
  SupabaseAuthRemoteDataSource(this.supabaseClient);

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final currentUser = supabaseClient.auth.currentUser;
      if (currentUser == null) return null;

      return UserEntity(
        id: currentUser.id,
        email: currentUser.email,
        name: currentUser.userMetadata?['name'] as String?,
        metadata: currentUser.userMetadata,
        createdAt:
            currentUser.createdAt.isNotEmpty
                ? DateTime.parse(currentUser.createdAt)
                : null,
        lastLoginAt:
            currentUser.lastSignInAt != null
                ? DateTime.parse(currentUser.lastSignInAt!)
                : null,
      );
    } on AuthException catch (e) {
      throw AuthException(e.message, code: 'supabase_auth_error');
    } catch (e) {
      throw ServerException(
        'Failed to get current user: ${e.toString()}',
        code: 'unexpected_error',
      );
    }
  }

  @override
  Future<UserEntity> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw const AuthException(
          'Sign in succeeded but no user was returned',
          code: 'no_user',
        );
      }

      return UserEntity(
        id: user.id,
        email: user.email,
        name: user.userMetadata?['name'] as String?,
        metadata: user.userMetadata,
        createdAt:
            user.createdAt.isNotEmpty ? DateTime.parse(user.createdAt) : null,
        lastLoginAt:
            user.lastSignInAt != null
                ? DateTime.parse(user.lastSignInAt!)
                : null,
      );
    } on AuthException catch (e) {
      throw AuthException(e.message, code: 'supabase_auth_error');
    } catch (e) {
      throw ServerException(
        'Failed to sign in: ${e.toString()}',
        code: 'unexpected_error',
      );
    }
  }

  @override
  Future<UserEntity> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      // Create metadata with name if provided
      final Map<String, dynamic> metadata = {};
      if (name != null && name.isNotEmpty) {
        metadata['name'] = name;
      }

      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: metadata,
      );

      final user = response.user;
      if (user == null) {
        throw const AuthException(
          'Sign up succeeded but no user was returned',
          code: 'no_user',
        );
      }

      return UserEntity(
        id: user.id,
        email: user.email,
        name: user.userMetadata?['name'] as String?,
        metadata: user.userMetadata,
        createdAt:
            user.createdAt.isNotEmpty ? DateTime.parse(user.createdAt) : null,
        lastLoginAt:
            user.lastSignInAt != null
                ? DateTime.parse(user.lastSignInAt!)
                : null,
      );
    } on AuthException catch (e) {
      throw AppAuthException(e.message, code: 'supabase_auth_error');
    } catch (e) {
      throw ServerException(
        'Failed to sign up: ${e.toString()}',
        code: 'unexpected_error',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      throw AppAuthException(e.message, code: 'supabase_auth_error');
    } catch (e) {
      throw ServerException(
        'Failed to sign out: ${e.toString()}',
        code: 'unexpected_error',
      );
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await supabaseClient.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw AppAuthException(e.message, code: 'supabase_auth_error');
    } catch (e) {
      throw ServerException(
        'Failed to send password reset: ${e.toString()}',
        code: 'unexpected_error',
      );
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return supabaseClient.auth.currentUser != null;
  }

  @override
  Future<UserEntity> updateUserProfile({String? displayName}) async {
    try {
      final currentUser = supabaseClient.auth.currentUser;
      if (currentUser == null) {
        throw const AuthException(
          'No authenticated user found',
          code: 'no_user',
        );
      }

      // Create new metadata with updated display name
      final Map<String, dynamic> newMetadata = Map.from(
        currentUser.userMetadata ?? {},
      );
      if (displayName != null) {
        newMetadata['name'] = displayName;
      }

      // Update the user metadata
      await supabaseClient.auth.updateUser(UserAttributes(data: newMetadata));

      // Return the updated user entity
      final updatedUser = supabaseClient.auth.currentUser;
      return UserEntity(
        id: updatedUser!.id,
        email: updatedUser.email,
        name: updatedUser.userMetadata?['name'] as String?,
        metadata: updatedUser.userMetadata,
        createdAt:
            updatedUser.createdAt.isNotEmpty
                ? DateTime.parse(updatedUser.createdAt)
                : null,
        lastLoginAt:
            updatedUser.lastSignInAt != null
                ? DateTime.parse(updatedUser.lastSignInAt!)
                : null,
      );
    } on AuthException catch (e) {
      throw AuthException(e.message, code: 'supabase_auth_error');
    } catch (e) {
      throw ServerException(
        'Failed to update user profile: ${e.toString()}',
        code: 'unexpected_error',
      );
    }
  }
}
