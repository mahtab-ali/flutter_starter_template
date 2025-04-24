import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:starter_template_flutter/config/localization/app_localizations.dart';
import 'package:starter_template_flutter/presentation/settings/bloc/localization/localization_state.dart';
import 'package:starter_template_flutter/presentation/settings/bloc/theme/theme_state.dart';

import '../config/themes/theme_data.dart';
import '../config/routes.dart';
import '../core/di/bloc_providers.dart';
import '../core/di/injection_container.dart';
import '../presentation/auth/bloc/app_auth_bloc.dart';
import '../presentation/auth/bloc/app_auth_event.dart';
import 'settings/bloc/localization/localization_bloc.dart';
import 'settings/bloc/theme/theme_bloc.dart';

/// The main application widget
class App extends StatelessWidget {
  /// Create the main application widget
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBlocProviders.providers,
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          // Initialize the blocs
          _initBlocs(context);

          return BlocBuilder<LocalizationBloc, LocalizationState>(
            builder: (context, localizationState) {
              // Pass the current locale to theme methods
              final currentLocale = localizationState.locale;

              return MaterialApp(
                title: 'Flutter Starter',
                theme: AppTheme.lightTheme(currentLocale),
                darkTheme: AppTheme.darkTheme(currentLocale),
                themeMode: _getThemeMode(themeState),
                locale: currentLocale,
                supportedLocales: const [Locale('en'), Locale('ar')],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                builder:
                    (context, child) => ResponsiveBreakpoints.builder(
                      child: child!,
                      breakpoints: [
                        const Breakpoint(start: 0, end: 450, name: MOBILE),
                        const Breakpoint(start: 451, end: 800, name: TABLET),
                        const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                        const Breakpoint(
                          start: 1921,
                          end: double.infinity,
                          name: '4K',
                        ),
                      ],
                    ),
                navigatorKey: sl<GlobalKey<NavigatorState>>(),
                initialRoute: AppRoutes.splash,
                onGenerateRoute: AppRoutes.onGenerateRoute,
              );
            },
          );
        },
      ),
    );
  }

  /// Initialize all the BLoCs
  void _initBlocs(BuildContext context) {
    // The ThemeBloc already loads theme settings in its constructor
    // No need to dispatch an event here

    // The LocalizationBloc will load saved settings from its constructor
    // No need to force English language here anymore

    // Check authentication status
    context.read<AppAuthBloc>().add(AuthCheckRequested());
  }

  /// Get the theme mode based on the theme state
  ThemeMode _getThemeMode(ThemeState state) {
    if (state.isSystemTheme) {
      return ThemeMode.system;
    }
    return state.isDarkMode == true ? ThemeMode.dark : ThemeMode.light;
  }
}
