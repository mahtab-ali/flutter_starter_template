import '../../../core/errors/result.dart';
import '../../repositories/theme_repository.dart';
import '../base_use_case.dart';

/// Use case for checking if the system theme setting is enabled
class GetSystemThemeStatusUseCase implements UseCaseNoParams<bool> {
  final ThemeRepository repository;

  GetSystemThemeStatusUseCase(this.repository);

  /// Execute the use case to check if system theme is enabled
  @override
  Future<Result<bool>> call() async {
    return await repository.isSystemThemeEnabled();
  }
}
