import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starter_template_flutter/core/network/network_info.dart';
import 'package:starter_template_flutter/data/datasources/remote/supabase_auth_remote_datasource.dart';
import 'package:starter_template_flutter/domain/usecases/auth/check_auth_status_use_case.dart';
import 'package:starter_template_flutter/domain/usecases/auth/get_current_user_use_case.dart';
import 'package:starter_template_flutter/domain/usecases/auth/reset_password_use_case.dart';
import 'package:starter_template_flutter/domain/usecases/auth/sign_in_use_case.dart';
import 'package:starter_template_flutter/domain/usecases/auth/sign_out_use_case.dart';
import 'package:starter_template_flutter/domain/usecases/auth/sign_up_use_case.dart';
import 'package:starter_template_flutter/domain/usecases/auth/update_user_profile_use_case.dart';
import 'package:starter_template_flutter/domain/usecases/theme/get_system_theme_status_use_case.dart';
import 'package:starter_template_flutter/domain/usecases/theme/get_theme_mode_use_case.dart';
import 'package:starter_template_flutter/domain/usecases/theme/set_system_theme_status_use_case.dart';
import 'package:starter_template_flutter/domain/usecases/theme/set_theme_mode_use_case.dart';
import 'package:starter_template_flutter/presentation/auth/bloc/app_auth_bloc.dart';
import 'package:starter_template_flutter/presentation/auth/bloc/app_auth_event.dart';
import 'package:starter_template_flutter/presentation/common/bloc/app_bloc.dart';
import 'package:starter_template_flutter/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:starter_template_flutter/presentation/settings/bloc/localization/localization_bloc.dart';
import 'package:starter_template_flutter/presentation/settings/bloc/theme/theme_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/repositories/auth_repository_impl.dart';
import 'injection_container.dart'; // Import the sl service locator

/// Dependency Injection class that centralizes all app dependencies
class DependencyInjection {
  // Private constructor to prevent instantiation
  DependencyInjection._();

  /// Get all BLoC providers for the application
  static List<BlocProvider> getBlocProviders() {
    final supabaseClient = Supabase.instance.client;

    // Create network info and data sources
    final networkInfo = NetworkInfoImpl();
    final authRemoteDataSource = SupabaseAuthRemoteDataSource(supabaseClient);

    // Create the auth repository
    final authRepository = AuthRepositoryImpl(
      remoteDataSource: authRemoteDataSource,
      networkInfo: networkInfo,
    );

    // Create use cases for auth-related operations
    final checkAuthStatusUseCase = CheckAuthStatusUseCase(authRepository);
    final getCurrentUserUseCase = GetCurrentUserUseCase(authRepository);
    final signInUseCase = SignInUseCase(authRepository);
    final signUpUseCase = SignUpUseCase(authRepository);
    final signOutUseCase = SignOutUseCase(authRepository);
    final resetPasswordUseCase = ResetPasswordUseCase(authRepository);
    final updateUserProfileUseCase = UpdateUserProfileUseCase(authRepository);

    // Get theme-related use cases from service locator
    final getThemeModeUseCase = sl<GetThemeModeUseCase>();
    final getSystemThemeStatusUseCase = sl<GetSystemThemeStatusUseCase>();
    final setThemeModeUseCase = sl<SetThemeModeUseCase>();
    final setSystemThemeStatusUseCase = sl<SetSystemThemeStatusUseCase>();

    // Create theme, locale, and onboarding use cases through service locator (sl)
    return [
      BlocProvider<AppBloc>(create: (context) => AppBloc()),
      BlocProvider<ThemeBloc>(
        create:
            (context) => ThemeBloc(
              getThemeModeUseCase: getThemeModeUseCase,
              getSystemThemeStatusUseCase: getSystemThemeStatusUseCase,
              setThemeModeUseCase: setThemeModeUseCase,
              setSystemThemeStatusUseCase: setSystemThemeStatusUseCase,
            ),
      ),
      // Create a lazy LocalizationBloc that will load saved preferences
      BlocProvider<LocalizationBloc>(
        lazy: false, // Important: Make it non-lazy so it loads immediately
        create: (context) => LocalizationBloc(),
      ),
      BlocProvider<OnboardingBloc>(create: (context) => OnboardingBloc()),
      BlocProvider<AppAuthBloc>(
        create:
            (context) => AppAuthBloc(
              checkAuthStatusUseCase: checkAuthStatusUseCase,
              getCurrentUserUseCase: getCurrentUserUseCase,
              signInUseCase: signInUseCase,
              signUpUseCase: signUpUseCase,
              signOutUseCase: signOutUseCase,
              resetPasswordUseCase: resetPasswordUseCase,
              updateUserProfileUseCase: updateUserProfileUseCase,
            )..add(AuthCheckRequested()),
      ),
    ];
  }

  /// Get a specific BLoC provider
  static BlocProvider<T> getSingleBlocProvider<T extends Cubit<Object?>>() {
    final supabaseClient = Supabase.instance.client;

    // Create network info and data sources
    final networkInfo = NetworkInfoImpl();
    final authRemoteDataSource = SupabaseAuthRemoteDataSource(supabaseClient);

    // Create the auth repository
    final authRepository = AuthRepositoryImpl(
      remoteDataSource: authRemoteDataSource,
      networkInfo: networkInfo,
    );

    // Create use cases for auth-related operations
    final checkAuthStatusUseCase = CheckAuthStatusUseCase(authRepository);
    final getCurrentUserUseCase = GetCurrentUserUseCase(authRepository);
    final signInUseCase = SignInUseCase(authRepository);
    final signUpUseCase = SignUpUseCase(authRepository);
    final signOutUseCase = SignOutUseCase(authRepository);
    final resetPasswordUseCase = ResetPasswordUseCase(authRepository);
    final updateUserProfileUseCase = UpdateUserProfileUseCase(authRepository);

    // Get theme-related use cases from service locator
    final getThemeModeUseCase = sl<GetThemeModeUseCase>();
    final getSystemThemeStatusUseCase = sl<GetSystemThemeStatusUseCase>();
    final setThemeModeUseCase = sl<SetThemeModeUseCase>();
    final setSystemThemeStatusUseCase = sl<SetSystemThemeStatusUseCase>();

    // Return the appropriate BLoC provider based on the type
    if (T == AppAuthBloc) {
      return BlocProvider<T>(
        create:
            (context) =>
                AppAuthBloc(
                      checkAuthStatusUseCase: checkAuthStatusUseCase,
                      getCurrentUserUseCase: getCurrentUserUseCase,
                      signInUseCase: signInUseCase,
                      signUpUseCase: signUpUseCase,
                      signOutUseCase: signOutUseCase,
                      resetPasswordUseCase: resetPasswordUseCase,
                      updateUserProfileUseCase: updateUserProfileUseCase,
                    )
                    as T,
      );
    } else if (T == ThemeBloc) {
      return BlocProvider<T>(
        create:
            (context) =>
                ThemeBloc(
                      getThemeModeUseCase: getThemeModeUseCase,
                      getSystemThemeStatusUseCase: getSystemThemeStatusUseCase,
                      setThemeModeUseCase: setThemeModeUseCase,
                      setSystemThemeStatusUseCase: setSystemThemeStatusUseCase,
                    )
                    as T,
      );
    } else if (T == LocalizationBloc) {
      return BlocProvider<T>(
        lazy: false, // Non-lazy to ensure it loads saved language immediately
        create: (context) => LocalizationBloc() as T,
      );
    } else if (T == OnboardingBloc) {
      return BlocProvider<T>(create: (context) => OnboardingBloc() as T);
    } else if (T == AppBloc) {
      return BlocProvider<T>(create: (context) => AppBloc() as T);
    }

    throw UnimplementedError('Provider for $T not implemented');
  }
}
