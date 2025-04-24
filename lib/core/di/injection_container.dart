import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/local/preferences_local_datasource.dart';
import '../../data/datasources/local/shared_preferences_local_datasource.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/datasources/remote/supabase_auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/localization_repository_impl.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import '../../data/repositories/theme_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/localization_repository.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../../domain/repositories/theme_repository.dart';
import '../../domain/usecases/auth/check_auth_status_use_case.dart';
import '../../domain/usecases/auth/get_current_user_use_case.dart';
import '../../domain/usecases/auth/reset_password_use_case.dart';
import '../../domain/usecases/auth/sign_in_use_case.dart';
import '../../domain/usecases/auth/sign_out_use_case.dart';
import '../../domain/usecases/auth/sign_up_use_case.dart';
import '../../domain/usecases/auth/update_user_profile_use_case.dart';
import '../../domain/usecases/localization/change_locale_use_case.dart';
import '../../domain/usecases/localization/get_current_locale_use_case.dart';
import '../../domain/usecases/onboarding/check_onboarding_status_use_case.dart';
import '../../domain/usecases/onboarding/complete_onboarding_use_case.dart';
import '../../domain/usecases/theme/get_system_theme_status_use_case.dart';
import '../../domain/usecases/theme/get_theme_mode_use_case.dart';
import '../../domain/usecases/theme/set_system_theme_status_use_case.dart';
import '../../domain/usecases/theme/set_theme_mode_use_case.dart';
import '../../domain/usecases/theme/toggle_theme_mode_use_case.dart';
import '../../presentation/navigation/app_navigator.dart';
import '../network/network_info.dart';
import '../services/app_service.dart';

/// Service locator instance
final sl = GetIt.instance;

/// Initialize all dependencies
Future<void> init() async {
  // External dependencies
  final supabaseClient = Supabase.instance.client;
  sl.registerLazySingleton<SupabaseClient>(() => supabaseClient);

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // Navigation
  final navigatorKey = GlobalKey<NavigatorState>();
  sl.registerLazySingleton<GlobalKey<NavigatorState>>(() => navigatorKey);
  sl.registerLazySingleton<AppNavigator>(
    () => AppNavigator(navigatorKey: sl()),
  );

  // Data sources
  sl.registerLazySingleton<PreferencesLocalDataSource>(
    () => SharedPreferencesLocalDataSource(sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => SupabaseAuthRemoteDataSource(sl()),
  );

  // Register components by feature modules
  await _initAuthModule();
  await _initThemeModule();
  await _initLocalizationModule();
  await _initOnboardingModule();

  // Services
  sl.registerLazySingleton<AppService>(() => AppService.fromServiceLocator());
}

/// Initialize authentication related dependencies
Future<void> _initAuthModule() async {
  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserProfileUseCase(sl()));
}

/// Initialize theme related dependencies
Future<void> _initThemeModule() async {
  // Repository
  sl.registerLazySingleton<ThemeRepository>(
    () => ThemeRepositoryImpl(localDataSource: sl(), networkInfo: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => ToggleThemeModeUseCase(sl()));
  sl.registerLazySingleton(() => GetThemeModeUseCase(sl()));
  sl.registerLazySingleton(() => GetSystemThemeStatusUseCase(sl()));
  sl.registerLazySingleton(() => SetThemeModeUseCase(sl()));
  sl.registerLazySingleton(() => SetSystemThemeStatusUseCase(sl()));
}

/// Initialize localization related dependencies
Future<void> _initLocalizationModule() async {
  // Repository
  sl.registerLazySingleton<LocalizationRepository>(
    () => LocalizationRepositoryImpl(
      localDataSource: sl(),
      networkInfo: sl(),
      supportedLocales: const [Locale('en'), Locale('ar')],
      fallbackLocale: const Locale('en'),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => ChangeLocaleUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentLocaleUseCase(sl()));
}

/// Initialize onboarding related dependencies
Future<void> _initOnboardingModule() async {
  // Repository
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(localDataSource: sl(), networkInfo: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => CompleteOnboardingUseCase(sl()));
  sl.registerLazySingleton(() => CheckOnboardingStatusUseCase(sl()));
}
