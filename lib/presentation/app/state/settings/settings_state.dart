part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final AppSetting? setting;

  const SettingsState({this.setting});

  @override
  List<Object?> get props => [setting];
}
