part of 'localization_cubit.dart';

class LocalizationState {
  final Language appLanguage;

  LocalizationState({required this.appLanguage});

  factory LocalizationState.initial() => LocalizationState(appLanguage: Language.az);
}
