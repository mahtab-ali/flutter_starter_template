import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_pkg;
import 'app_auth_event.dart';
import 'app_auth_state.dart';

class AppAuthBloc extends Bloc<AppAuthEvent, AppAuthState> {
  final supabase_pkg.SupabaseClient supabase;

  AppAuthBloc({required this.supabase}) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthResetPasswordRequested>(_onAuthResetPasswordRequested);
    on<UpdateUserDataRequested>(_onUpdateUserDataRequested);
  }

  void _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AppAuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser != null) {
        emit(AuthAuthenticated(user: currentUser));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AppAuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final response = await supabase.auth.signInWithPassword(
        email: event.email,
        password: event.password,
      );

      if (response.user != null) {
        emit(AuthAuthenticated(user: response.user!));
      } else {
        emit(AuthError(message: 'Login failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AppAuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final response = await supabase.auth.signUp(
        email: event.email,
        password: event.password,
        data: {
          'name': event.name,
          'email': event.email,
          'email_verified': true,
          'phone_verified': false,
        },
      );

      if (response.user != null) {
        emit(AuthAuthenticated(user: response.user!));
      } else {
        emit(AuthError(message: 'Registration failed'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AppAuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await supabase.auth.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void _onAuthResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AppAuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      // Reset password using Supabase
      await supabase.auth.resetPasswordForEmail(
        event.email,
        redirectTo: null, // You can add a redirect URL if needed
      );

      // If successful, emit success state with the email
      emit(AuthPasswordResetSuccess(email: event.email));
    } catch (e) {
      // If there's an error, emit failure state with the error message
      emit(AuthPasswordResetFailure(error: e.toString()));
    }
  }

  void _onUpdateUserDataRequested(
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

    try {
      // Update the user metadata
      final userAttributes = supabase_pkg.UserAttributes();

      // Only update fields that were provided
      if (event.displayName != null) {
        userAttributes.data = {'name': event.displayName};
      }

      // Update the user
      final response = await supabase.auth.updateUser(userAttributes);

      if (response.user != null) {
        // Emit success with the updated user
        emit(AuthAuthenticated(user: response.user!));
      } else {
        // Restore previous state if update failed
        emit(currentState);
        emit(AuthError(message: 'Failed to update user data'));
      }
    } catch (e) {
      // Restore previous state and emit error
      emit(currentState);
      emit(AuthError(message: e.toString()));
    }
  }
}
