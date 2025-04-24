import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/errors/result.dart';
import 'package:starter_template_flutter/domain/usecases/auth/reset_password_use_case.dart';
import 'package:starter_template_flutter/domain/usecases/auth/update_user_profile_use_case.dart';

import '../../../domain/usecases/auth/check_auth_status_use_case.dart';
import '../../../domain/usecases/auth/get_current_user_use_case.dart';
import '../../../domain/usecases/auth/sign_in_use_case.dart';
import '../../../domain/usecases/auth/sign_out_use_case.dart';
import '../../../domain/usecases/auth/sign_up_use_case.dart';
import 'app_auth_event.dart';
import 'app_auth_state.dart';

/// BLoC for handling authentication flow
class AppAuthBloc extends Bloc<AppAuthEvent, AppAuthState> {
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;

  /// Create a new AppAuthBloc with required dependencies
  AppAuthBloc({
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required UpdateUserProfileUseCase updateUserProfileUseCase,
  }) : _checkAuthStatusUseCase = checkAuthStatusUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _signInUseCase = signInUseCase,
       _signUpUseCase = signUpUseCase,
       _signOutUseCase = signOutUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
       _updateUserProfileUseCase = updateUserProfileUseCase,
       super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthResetPasswordRequested>(_onAuthResetPasswordRequested);
    on<UpdateUserDataRequested>(_onUpdateUserDataRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AppAuthState> emit,
  ) async {
    emit(AuthLoading());

    final authStatusResult = await _checkAuthStatusUseCase();

    final authStatus = authStatusResult.when(
      onFailure: (failure) {
        emit(AuthError(message: failure.message));
        return null;
      },
      onSuccess: (isAuthenticated) => isAuthenticated,
    );

    // If we got an error, we've already emitted the state
    if (authStatus == null) return;

    // If not authenticated, emit unauthenticated state
    if (!authStatus) {
      emit(AuthUnauthenticated());
      return;
    }

    // Get current user
    final userResult = await _getCurrentUserUseCase();

    final user = userResult.when(
      onFailure: (failure) {
        emit(AuthError(message: failure.message));
        return null;
      },
      onSuccess: (user) => user,
    );

    // If we got an error, we've already emitted the state
    if (user == null) {
      emit(AuthUnauthenticated());
      return;
    }

    emit(AuthAuthenticated(user: user));
  }

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AppAuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _signInUseCase(
      SignInParams(email: event.email, password: event.password),
    );

    result.when(
      onFailure: (failure) => emit(AuthError(message: failure.message)),
      onSuccess: (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AppAuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _signUpUseCase(
      SignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    result.when(
      onFailure: (failure) => emit(AuthError(message: failure.message)),
      onSuccess: (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AppAuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _signOutUseCase();

    result.when(
      onFailure: (failure) => emit(AuthError(message: failure.message)),
      onSuccess: (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onAuthResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AppAuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _resetPasswordUseCase(
      ResetPasswordParams(email: event.email),
    );

    result.fold(
      (error) => emit(AuthPasswordResetFailure(error: error.message)),
      (_) => emit(AuthPasswordResetSuccess(email: event.email)),
    );
  }

  Future<void> _onUpdateUserDataRequested(
    UpdateUserDataRequested event,
    Emitter<AppAuthState> emit,
  ) async {
    // First get current state to avoid disrupting authentication
    final currentState = state;
    if (currentState is! AuthAuthenticated) {
      emit(
        AuthError(message: 'Cannot update user data while not authenticated'),
      );
      return;
    }

    // Emit loading without changing authentication state
    emit(AuthLoading());

    // Call the update user profile use case with the display name
    final result = await _updateUserProfileUseCase(
      UpdateUserProfileParams(displayName: event.displayName),
    );

    result.when(
      onFailure: (failure) => emit(AuthError(message: failure.message)),
      onSuccess: (updatedUser) => emit(AuthAuthenticated(user: updatedUser)),
    );
  }
}
