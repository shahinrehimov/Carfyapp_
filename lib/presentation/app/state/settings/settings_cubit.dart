import 'package:carfy/common/di/di.dart';
import 'package:carfy/domain/entities/setting/app_setting.dart';
import 'package:carfy/domain/use_cases/setting/get_setting_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetSettingUseCase _getSettingUseCase;

  SettingsCubit({GetSettingUseCase? getSettingUseCase})
      : _getSettingUseCase = getSettingUseCase ?? getIt<GetSettingUseCase>(),
        super(const SettingsState());

  Future<void> load() async {
    final result = await _getSettingUseCase();
    result.fold((_) {}, (setting) => emit(SettingsState(setting: setting)));
  }
}
