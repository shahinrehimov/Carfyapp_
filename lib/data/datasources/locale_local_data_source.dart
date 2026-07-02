import 'package:carfy/common/constants/preference_keys.dart';
import 'package:carfy/common/util/pref_util.dart';
import 'package:injectable/injectable.dart';

abstract class LocaleLocalDataSource {
  Future<String?> getSelectedLanguage();
  Future<void> saveSelectedLanguage(String code);

  Future<int> getTranslationVersion(String code);
  Future<void> saveTranslationVersion(String code, int version);
}

@Injectable(as: LocaleLocalDataSource)
class LocaleLocalDataSourceImpl extends LocaleLocalDataSource {
  @override
  Future<String?> getSelectedLanguage() async => PrefUtil.getString(AppPreferenceKeys.selectedLanguage);

  @override
  Future<void> saveSelectedLanguage(String code) async {
    await PrefUtil.setString(AppPreferenceKeys.selectedLanguage, code);
  }

  @override
  Future<int> getTranslationVersion(String code) async {
    return PrefUtil.getInt(AppPreferenceKeys.lastSavedRemoteLanguage(code)) ?? 0;
  }

  @override
  Future<void> saveTranslationVersion(String code, int version) async {
    await PrefUtil.setInt(AppPreferenceKeys.lastSavedRemoteLanguage(code), version);
  }
}
