part of 'localization_cubit.dart';

class LocalizationState extends Equatable {
  final Language appLanguage;
  final int timestamp; // Add timestamp to trigger rebuilds

  const LocalizationState({required this.appLanguage, required this.timestamp});

  factory LocalizationState.initial() =>
      LocalizationState(appLanguage: Language.fromValue('az'), timestamp: DateTime.now().millisecondsSinceEpoch);

  LocalizationState copyWith({Language? appLanguage, int? timestamp}) {
    return LocalizationState(
      appLanguage: appLanguage ?? this.appLanguage,
      timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  @override
  List<Object?> get props => [appLanguage, timestamp];
}
