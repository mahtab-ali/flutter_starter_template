import 'dart:ui';

import '../../../core/errors/result.dart';
import '../../repositories/localization_repository.dart';
import '../base_use_case.dart';

/// Use case for getting the current locale
class GetCurrentLocaleUseCase implements UseCaseNoParams<Locale> {
  final LocalizationRepository repository;

  GetCurrentLocaleUseCase(this.repository);

  @override
  Future<Result<Locale>> call() async {
    return await repository.getCurrentLocale();
  }
}
