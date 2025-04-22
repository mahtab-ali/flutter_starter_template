import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../blocs/auth/app_auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/localization/localization_bloc.dart';
import '../blocs/theme/theme_bloc.dart';

/// Dependency Injection class that centralizes all app dependencies
class DependencyInjection {
  // Private constructor to prevent instantiation
  DependencyInjection._();

  /// Get all BLoC providers for the application
  static List<BlocProvider> getBlocProviders() {
    final supabaseClient = Supabase.instance.client;

    return [
      BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),
      BlocProvider<LocalizationBloc>(create: (context) => LocalizationBloc()),
      BlocProvider<AppAuthBloc>(
        create:
            (context) =>
                AppAuthBloc(supabase: supabaseClient)
                  ..add(AuthCheckRequested()),
      ),
    ];
  }

  /// Get a specific BLoC provider
  static BlocProvider<T> getSingleBlocProvider<T extends Cubit<Object?>>() {
    final supabaseClient = Supabase.instance.client;

    // Return the appropriate BLoC provider based on the type
    if (T == AppAuthBloc) {
      return BlocProvider<T>(
        create: (context) => AppAuthBloc(supabase: supabaseClient) as T,
      );
    } else if (T == ThemeBloc) {
      return BlocProvider<T>(create: (context) => ThemeBloc() as T);
    } else if (T == LocalizationBloc) {
      return BlocProvider<T>(create: (context) => LocalizationBloc() as T);
    }

    throw UnimplementedError('Provider for $T not implemented');
  }
}
