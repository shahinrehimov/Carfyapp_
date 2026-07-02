import 'package:carfy/common/constants/preference_keys.dart';
import 'package:carfy/common/util/pref_util.dart';
import 'package:injectable/injectable.dart';

abstract class AuthLocalDataSource {
  Future<String?> getAuthToken();
  Future<void> saveAuthToken(String token);
  Future<void> clearAuthToken();

  Future<String?> getGuestIdentifier();
  Future<void> saveGuestIdentifier(String id);
  Future<void> clearGuestIdentifier();
}

@Injectable(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl extends AuthLocalDataSource {
  @override
  Future<String?> getAuthToken() async => PrefUtil.getString(AppPreferenceKeys.authToken);

  @override
  Future<void> saveAuthToken(String token) async {
    await PrefUtil.setString(AppPreferenceKeys.authToken, token);
  }

  @override
  Future<void> clearAuthToken() async {
    await PrefUtil.remove(AppPreferenceKeys.authToken);
  }

  @override
  Future<String?> getGuestIdentifier() async => PrefUtil.getString(AppPreferenceKeys.guestIdentifier);

  @override
  Future<void> saveGuestIdentifier(String id) async {
    await PrefUtil.setString(AppPreferenceKeys.guestIdentifier, id);
  }

  @override
  Future<void> clearGuestIdentifier() async {
    await PrefUtil.remove(AppPreferenceKeys.guestIdentifier);
  }
}
