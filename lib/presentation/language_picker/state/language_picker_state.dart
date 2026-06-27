part of 'language_picker_cubit.dart';

class LanguagePickerState extends Equatable {
  final StateStatus status;
  final List<AppLanguage> languages;

  const LanguagePickerState({required this.status, this.languages = const []});

  factory LanguagePickerState.initial() => LanguagePickerState(status: StateStatus.initial());

  LanguagePickerState copyWith({StateStatus? status, List<AppLanguage>? languages}) {
    return LanguagePickerState(status: status ?? this.status, languages: languages ?? this.languages);
  }

  @override
  List<Object?> get props => [status, languages];
}
