abstract class LocalizationEvent {}

class LocaleChanged extends LocalizationEvent {
  final String languageCode;

  LocaleChanged({required this.languageCode});
}
