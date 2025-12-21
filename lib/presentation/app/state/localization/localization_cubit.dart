import 'package:carfy/common/constants/preference_keys.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/translations/default_translations.dart';
import 'package:carfy/common/util/pref_util.dart';
import 'package:carfy/domain/use_cases/translations/get_cached_translations_use_case.dart';
import 'package:carfy/domain/use_cases/translations/get_remote_translations_use_case.dart';
import 'package:carfy/domain/use_cases/translations/save_translations_use_case.dart';
import 'package:carfy/domain/use_cases/version/get_versions_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:carfy/common/enums/language.dart';
import 'package:carfy/domain/entities/translation/translations.dart';

part 'localization_state.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  final GetVersionsUseCase _getVersionsUseCase;
  final GetRemoteTranslationsUseCase _getRemoteTranslationsUseCase;
  final GetCachedTranslationsUseCase _getCachedTranslationsUseCase;
  final SaveTranslationsUseCase _saveTranslationsUseCase;

  LocalizationCubit({
    GetVersionsUseCase? getVersionsUseCase,
    GetRemoteTranslationsUseCase? getRemoteTranslationsUseCase,
    GetCachedTranslationsUseCase? getCachedTranslationsUseCase,
    SaveTranslationsUseCase? saveTranslationsUseCase,
  }) : _getVersionsUseCase = getVersionsUseCase ?? getIt<GetVersionsUseCase>(),
       _getRemoteTranslationsUseCase = getRemoteTranslationsUseCase ?? getIt<GetRemoteTranslationsUseCase>(),
       _getCachedTranslationsUseCase = getCachedTranslationsUseCase ?? getIt<GetCachedTranslationsUseCase>(),
       _saveTranslationsUseCase = saveTranslationsUseCase ?? getIt<SaveTranslationsUseCase>(),
       super(LocalizationState.initial());

  Map<String, String> trMap = TranslationDefaults.defaults['az']!;

  Future<void> init() async {
    _loadLastSelectedDefault();
    // await _loadCachedTranslations();
    // await _checkRemoteLanguageVersion();
  }

  void _loadLastSelectedDefault() {
    final langStr = PrefUtil.getString(AppPreferenceKeys.selectedLanguage) ?? 'az';
    trMap = TranslationDefaults.defaults[langStr]!;
    Language language = Language.fromValue(langStr);
    emit(state.copyWith(appLanguage: language));
  }

  Future<void> _loadCachedTranslations() async {
    final result = await _getCachedTranslationsUseCase.call(state.appLanguage.locale.languageCode);
    result.fold((failure) {}, (translations) async {
      if (translations != null) {
        trMap = translations.translations;
        emit(state.copyWith());
      }
    });
  }

  Future<void> _checkRemoteLanguageVersion() async {
    final result = await _getVersionsUseCase.call();
    result.fold((failure) {}, (versionEntity) {
      final remoteVersion = versionEntity.langVersion;
      final localVersion =
          PrefUtil.getInt(AppPreferenceKeys.lastSavedRemoteLanguage(state.appLanguage.locale.languageCode)) ?? 0;
      if (remoteVersion > localVersion) {
        _syncTranslations(remoteVersion);
      }
    });
  }

  void _syncTranslations(int remoteVersion) async {
    final remoteTranslationResult = await _getRemoteTranslationsUseCase.call(state.appLanguage.locale.languageCode);
    await remoteTranslationResult.fold((failure) {}, (translation) async {
      trMap = translation.translations;
      emit(state.copyWith());
      _saveTranslations(state.appLanguage.locale.languageCode, translation, remoteVersion);
    });
  }

  Future<void> _saveTranslations(String languageCode, Translations translation, int remoteVersion) async {
    final result = await _saveTranslationsUseCase.call(languageCode, translation);
    result.fold((failure) {}, (success) {
      PrefUtil.setInt(AppPreferenceKeys.lastSavedRemoteLanguage(languageCode), remoteVersion);
    });
  }

  void changeLanguage(String languageCode) {
    final language = Language.fromValue(languageCode);
    PrefUtil.setString(AppPreferenceKeys.selectedLanguage, languageCode);

    // Update trMap with default values first
    trMap = TranslationDefaults.defaults[languageCode]!;
    emit(LocalizationState(appLanguage: language, timestamp: DateTime.now().millisecondsSinceEpoch));

    // Then load cached and remote translations
    _loadCachedTranslations();
    _checkRemoteLanguageVersion();
  }

  String tr({required String key}) => _getCurrentValueByKey(key: key) ?? key;

  String? _getCurrentValueByKey({required String key}) => trMap[key];
}
