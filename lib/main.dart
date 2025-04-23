import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'blocs/localization/localization_bloc.dart';
import 'blocs/localization/localization_state.dart';
import 'blocs/theme/theme_bloc.dart';
import 'blocs/theme/theme_state.dart';
import 'config/app_config.dart';
import 'config/routes.dart';
import 'core/dependency_injection.dart';
import 'i18n/app_localizations.dart';
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
              // Get the current locale from localization state
              final currentLocale = localizationState.locale;

              // No need for explicit SystemChrome calls or AnnotatedRegion since
              // we're now handling system UI styling in the theme data
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Starter Template',
                theme: AppTheme.lightTheme(currentLocale),
                darkTheme: AppTheme.darkTheme(currentLocale),
                themeMode:
                    themeState.isSystemTheme
                        ? ThemeMode.system
                        : themeState.isDarkMode == true
                        ? ThemeMode.dark
                        : ThemeMode.light,
                locale: currentLocale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: AppConfig.supportedLocales,
                scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
                initialRoute: AppRoutes.splash,
                onGenerateRoute: AppRoutes.onGenerateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
