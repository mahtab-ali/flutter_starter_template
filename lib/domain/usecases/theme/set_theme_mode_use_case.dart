import '../../../core/errors/result.dart';
import '../../repositories/theme_repository.dart';
import '../base_use_case.dart';

/// Use case for setting a specific theme mode
class SetThemeModeUseCase implements UseCase<void, bool> {
  final ThemeRepository repository;

  SetThemeModeUseCase(this.repository);

  /// Execute the use case to set specific theme mode
  /// [params]: The theme mode to set (true for dark, false for light)
  @override
  Future<Result<void>> call(bool params) async {
    return await repository.setDarkModeEnabled(params);
  }
}
