import 'dart:ui';

import '../../core/errors/result.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/localization_repository.dart';
import '../datasources/local/preferences_local_datasource.dart';
import 'base_repository.dart';

/// Implementation of [LocalizationRepository]
class LocalizationRepositoryImpl extends BaseRepository
    implements LocalizationRepository {
  final PreferencesLocalDataSource localDataSource;
  final List<Locale> supportedLocales;
  final Locale fallbackLocale;

  /// Create a new instance with the required dependencies
  LocalizationRepositoryImpl({
    required this.localDataSource,
    required NetworkInfo networkInfo,
    required this.supportedLocales,
    required this.fallbackLocale,
  }) : super(networkInfo);

  @override
  Future<Result<Locale>> getCurrentLocale() async {
    return safeLocalCall(() async {
      final storedLocale = await localDataSource.getLocale();
      return storedLocale ?? fallbackLocale;
    });
  }

  @override
  List<Locale> getSupportedLocales() {
    return supportedLocales;
  }

  @override
  bool isSupportedLocale(Locale locale) {
    return supportedLocales.any(
      (supported) =>
          supported.languageCode == locale.languageCode &&
          (supported.countryCode == null ||
              supported.countryCode == locale.countryCode),
    );
  }

  @override
  Future<Result<void>> setLocale(Locale locale) async {
    return safeLocalCall(() => localDataSource.saveLocale(locale));
  }
}
