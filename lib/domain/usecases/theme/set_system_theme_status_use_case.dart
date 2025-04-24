import '../../../core/errors/result.dart';
import '../../repositories/theme_repository.dart';
import '../base_use_case.dart';

/// Use case for setting whether system theme should be used
class SetSystemThemeStatusUseCase implements UseCase<void, bool> {
  final ThemeRepository repository;

  SetSystemThemeStatusUseCase(this.repository);

  /// Execute the use case to set system theme status
  /// [params]: Whether to use system theme (true) or not (false)
  @override
  Future<Result<void>> call(bool params) async {
    return await repository.setSystemThemeEnabled(params);
  }
}
