import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Added import for SystemChrome
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:starter_template_flutter/blocs/localization/localization_bloc.dart';
import 'package:starter_template_flutter/blocs/theme/theme_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'i18n/app_localizations.dart';

import 'blocs/localization/localization_state.dart';
import 'blocs/theme/theme_state.dart';
import 'config/app_config.dart';
import 'core/dependency_injection.dart';
import 'screens/splash_screen.dart';
import 'themes/theme_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: DependencyInjection.getBlocProviders(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LocalizationBloc, LocalizationState>(
            builder: (context, localizationState) {
              // Determine if dark mode is active
              final isDarkMode =
                  themeState.isSystemTheme
                      ? MediaQuery.platformBrightnessOf(context) ==
                          Brightness.dark
                      : themeState.isDarkMode == true;

              // Update status bar styling based on theme
              SystemChrome.setSystemUIOverlayStyle(
                isDarkMode
                    ? const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarBrightness: Brightness.dark,
                      statusBarIconBrightness: Brightness.light,
                      systemNavigationBarColor: Colors.transparent,
                      systemNavigationBarIconBrightness: Brightness.light,
                    )
                    : const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarBrightness: Brightness.light,
                      statusBarIconBrightness: Brightness.dark,
                      systemNavigationBarColor: Colors.transparent,
                      systemNavigationBarIconBrightness: Brightness.dark,
                    ),
              );

              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Starter Template',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode:
                    themeState.isSystemTheme
                        ? ThemeMode.system
                        : themeState.isDarkMode == true
                        ? ThemeMode.dark
                        : ThemeMode.light,
                locale: localizationState.locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppConfig.supportedLocales,
                scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
                home: const SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
