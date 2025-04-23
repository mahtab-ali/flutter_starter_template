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
        data: {'name': event.name},
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
}
