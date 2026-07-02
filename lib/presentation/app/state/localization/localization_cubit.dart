import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/translations/default_translations.dart';
import 'package:carfy/domain/use_cases/translations/get_cached_translations_use_case.dart';
import 'package:carfy/domain/use_cases/translations/get_remote_translations_use_case.dart';
import 'package:carfy/domain/use_cases/translations/get_selected_language_use_case.dart';
import 'package:carfy/domain/use_cases/translations/get_translation_version_use_case.dart';
import 'package:carfy/domain/use_cases/translations/save_selected_language_use_case.dart';
import 'package:carfy/domain/use_cases/translations/save_translation_version_use_case.dart';
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
  final GetSelectedLanguageUseCase _getSelectedLanguageUseCase;
  final SaveSelectedLanguageUseCase _saveSelectedLanguageUseCase;
  final GetTranslationVersionUseCase _getTranslationVersionUseCase;
  final SaveTranslationVersionUseCase _saveTranslationVersionUseCase;

  LocalizationCubit({
    GetVersionsUseCase? getVersionsUseCase,
    GetRemoteTranslationsUseCase? getRemoteTranslationsUseCase,
    GetCachedTranslationsUseCase? getCachedTranslationsUseCase,
    SaveTranslationsUseCase? saveTranslationsUseCase,
    GetSelectedLanguageUseCase? getSelectedLanguageUseCase,
    SaveSelectedLanguageUseCase? saveSelectedLanguageUseCase,
    GetTranslationVersionUseCase? getTranslationVersionUseCase,
    SaveTranslationVersionUseCase? saveTranslationVersionUseCase,
  })  : _getVersionsUseCase = getVersionsUseCase ?? getIt<GetVersionsUseCase>(),
        _getRemoteTranslationsUseCase = getRemoteTranslationsUseCase ?? getIt<GetRemoteTranslationsUseCase>(),
        _getCachedTranslationsUseCase = getCachedTranslationsUseCase ?? getIt<GetCachedTranslationsUseCase>(),
        _saveTranslationsUseCase = saveTranslationsUseCase ?? getIt<SaveTranslationsUseCase>(),
        _getSelectedLanguageUseCase = getSelectedLanguageUseCase ?? getIt<GetSelectedLanguageUseCase>(),
        _saveSelectedLanguageUseCase = saveSelectedLanguageUseCase ?? getIt<SaveSelectedLanguageUseCase>(),
        _getTranslationVersionUseCase = getTranslationVersionUseCase ?? getIt<GetTranslationVersionUseCase>(),
        _saveTranslationVersionUseCase = saveTranslationVersionUseCase ?? getIt<SaveTranslationVersionUseCase>(),
        super(LocalizationState.initial());

  Map<String, String> trMap = TranslationDefaults.defaults['az'] ?? {};

  Future<void> init() async {
    await _loadLastSelectedDefault();
    await _loadCachedTranslations();
    await _checkRemoteLanguageVersion();
  }

  Future<void> _loadLastSelectedDefault() async {
    final result = await _getSelectedLanguageUseCase();
    final langStr = result.getOrElse(() => null) ?? 'az';
    trMap = TranslationDefaults.defaults[langStr] ?? {};
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
    final versionResult = await _getVersionsUseCase.call();
    await versionResult.fold((failure) async {}, (versionEntity) async {
      final remoteVersion = versionEntity.langVersion;
      final localResult = await _getTranslationVersionUseCase(state.appLanguage.locale.languageCode);
      final localVersion = localResult.getOrElse(() => 0);
      if (remoteVersion > localVersion) {
        await _syncTranslations(remoteVersion);
      }
    });
  }

  Future<void> _syncTranslations(int remoteVersion) async {
    final remoteTranslationResult = await _getRemoteTranslationsUseCase.call(state.appLanguage.locale.languageCode);
    await remoteTranslationResult.fold((failure) async {}, (translation) async {
      trMap = translation.translations;
      emit(state.copyWith());
      await _saveTranslations(state.appLanguage.locale.languageCode, translation, remoteVersion);
    });
  }

  Future<void> _saveTranslations(String languageCode, Translations translation, int remoteVersion) async {
    final result = await _saveTranslationsUseCase.call(languageCode, translation);
    await result.fold((failure) async {}, (success) async {
      await _saveTranslationVersionUseCase(languageCode, remoteVersion);
    });
  }

  Future<void> changeLanguage(String languageCode) async {
    final language = Language.fromValue(languageCode);
    await _saveSelectedLanguageUseCase(languageCode);

    // Update trMap with default values first
    trMap = TranslationDefaults.defaults[languageCode] ?? {};
    emit(LocalizationState(appLanguage: language, timestamp: DateTime.now().millisecondsSinceEpoch));

    // Then load cached and remote translations
    await _loadCachedTranslations();
    await _checkRemoteLanguageVersion();
  }

  String tr({required String key}) => _getCurrentValueByKey(key: key) ?? key;

  String? _getCurrentValueByKey({required String key}) => trMap[key];
}
