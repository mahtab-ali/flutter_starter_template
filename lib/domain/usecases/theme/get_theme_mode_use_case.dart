import '../../../core/errors/result.dart';
import '../../repositories/theme_repository.dart';
import '../base_use_case.dart';

/// Use case for getting the current theme mode setting
class GetThemeModeUseCase implements UseCaseNoParams<bool> {
  final ThemeRepository repository;

  GetThemeModeUseCase(this.repository);

  /// Execute the use case to get current dark mode status
  /// Returns true for dark mode, false for light mode
  @override
  Future<Result<bool>> call() async {
    return await repository.isDarkModeEnabled();
  }
}
