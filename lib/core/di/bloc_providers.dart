import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/theme/get_system_theme_status_use_case.dart';
import '../../domain/usecases/theme/get_theme_mode_use_case.dart';
import '../../domain/usecases/theme/set_system_theme_status_use_case.dart';
import '../../domain/usecases/theme/set_theme_mode_use_case.dart';
import '../../presentation/common/bloc/app_bloc.dart';
import '../../presentation/auth/bloc/app_auth_bloc.dart';
import '../../presentation/settings/bloc/localization_bloc.dart';
import '../../presentation/onboarding/bloc/onboarding_bloc.dart';
import '../../presentation/settings/bloc/theme_bloc.dart';
import 'injection_container.dart';

/// Utility class to provide all BLoC providers
class AppBlocProviders {
  // Private constructor to prevent instantiation
  AppBlocProviders._();

  /// Get all BLoC providers
  static List<BlocProvider> get providers => [
    BlocProvider<AppAuthBloc>(
      create:
          (context) => AppAuthBloc(
            checkAuthStatusUseCase: sl(),
            getCurrentUserUseCase: sl(),
            signInUseCase: sl(),
            signUpUseCase: sl(),
            signOutUseCase: sl(),
            resetPasswordUseCase: sl(),
            updateUserProfileUseCase: sl(),
          ),
    ),
    BlocProvider<ThemeBloc>(
      create:
          (context) => ThemeBloc(
            getThemeModeUseCase: sl<GetThemeModeUseCase>(),
            getSystemThemeStatusUseCase: sl<GetSystemThemeStatusUseCase>(),
            setThemeModeUseCase: sl<SetThemeModeUseCase>(),
            setSystemThemeStatusUseCase: sl<SetSystemThemeStatusUseCase>(),
          ),
    ),
    // Make LocalizationBloc non-lazy to ensure it loads saved language immediately
    BlocProvider<LocalizationBloc>(
      lazy: false,
      create: (context) => LocalizationBloc(),
    ),
    BlocProvider<OnboardingBloc>(create: (context) => OnboardingBloc()),
    BlocProvider<AppBloc>(create: (context) => AppBloc()),
  ];
}
