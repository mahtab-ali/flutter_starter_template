import '../../core/errors/result.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/theme_repository.dart';
import '../datasources/local/preferences_local_datasource.dart';
import 'base_repository.dart';

/// Implementation of [ThemeRepository]
class ThemeRepositoryImpl extends BaseRepository implements ThemeRepository {
  final PreferencesLocalDataSource localDataSource;

  /// Create a new instance with the required dependencies
  ThemeRepositoryImpl({
    required this.localDataSource,
    required NetworkInfo networkInfo,
  }) : super(networkInfo);

  @override
  Future<Result<bool>> isDarkModeEnabled() async {
    return safeLocalCall(() => localDataSource.isDarkModeEnabled());
  }

  @override
  Future<Result<bool>> isSystemThemeEnabled() async {
    return safeLocalCall(() => localDataSource.isSystemThemeEnabled());
  }

  @override
  Future<Result<void>> setDarkModeEnabled(bool isDarkMode) async {
    return safeLocalCall(() => localDataSource.setDarkModeEnabled(isDarkMode));
  }

  @override
  Future<Result<void>> setSystemThemeEnabled(bool useSystemTheme) async {
    return safeLocalCall(
      () => localDataSource.setSystemThemeEnabled(useSystemTheme),
    );
  }
}
