import 'dart:ui';

import '../../../core/errors/exceptions.dart';
import '../../../core/errors/result.dart';
import '../../repositories/localization_repository.dart';
import '../base_use_case.dart';

/// Parameters for change locale use case
class ChangeLocaleParams {
  final Locale locale;

  const ChangeLocaleParams(this.locale);
}

/// Use case for changing the app locale
class ChangeLocaleUseCase implements UseCase<void, ChangeLocaleParams> {
  final LocalizationRepository repository;

  ChangeLocaleUseCase(this.repository);

  @override
  Future<Result<void>> call(ChangeLocaleParams params) async {
    // First check if the locale is supported
    if (!repository.isSupportedLocale(params.locale)) {
      return Results.failure(
        const ValidationException('Locale is not supported'),
      );
    }

    return await repository.setLocale(params.locale);
  }
}
