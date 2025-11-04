import 'package:carfy/common/constants/preference_keys.dart';
import 'package:carfy/common/util/pref_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/enums/language.dart';

part 'localization_state.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  LocalizationCubit() : super(LocalizationState.initial());

  Future<void> init() async {
    _loadLastSelected();
  }

  void _loadLastSelected() {
    String langStr = PrefUtil.getString(AppPreferenceKeys.selectedLanguage) ?? 'az';
    Language language = Language.fromValue(langStr);
    emit(LocalizationState(appLanguage: language));
  }
}
