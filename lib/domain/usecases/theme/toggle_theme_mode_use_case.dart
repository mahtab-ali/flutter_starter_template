import '../../../core/errors/result.dart';
import '../../repositories/theme_repository.dart';
import '../base_use_case.dart';

/// Use case for toggling theme mode (dark/light)
class ToggleThemeModeUseCase implements UseCaseNoParams<bool> {
  final ThemeRepository repository;

  ToggleThemeModeUseCase(this.repository);

  @override
  /// Execute the toggle theme mode use case
  /// Returns the new theme mode status (true for dark, false for light)
  Future<Result<bool>> call() async {
    final currentModeResult = await repository.isDarkModeEnabled();

    // Return early if there was an error getting the current mode
    if (currentModeResult.isFailure) {
      return Results.failure(currentModeResult.error);
    }
    
    // Get the current mode and toggle it
    final isDarkMode = currentModeResult.data;
    final newMode = !isDarkMode;
    
    // Set the new mode
    final setResult = await repository.setDarkModeEnabled(newMode);
    
    // Return the new mode if setting was successful, otherwise return the error
    if (setResult.isSuccess) {
      return Results.success(newMode);
    } else {
      return Results.failure(setResult.error);
    }
  }
}
