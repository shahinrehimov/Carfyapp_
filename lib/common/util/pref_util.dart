import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class PrefUtil {
  static late final SharedPreferences preferences;
  static bool _init = false;
  static const String _key = 'hMmkzN9iWXuzLNQw0YHCUN7SzS0nqV7W';
  static const String _iv = 'sOFy9ULID2HJeziE';
  static final _encryptor = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8(_key), mode: encrypt.AESMode.cbc));
  static final _ivObject = encrypt.IV.fromUtf8(_iv);

  static Future init() async {
    if (_init) return;
    preferences = await SharedPreferences.getInstance();
    await preferences.reload();
    _init = true;
    return preferences;
  }

  static String _encryptData(String plainText) {
    final encrypted = _encryptor.encrypt(plainText, iv: _ivObject);
    return encrypted.base64;
  }

  static String _decryptData(String encryptedText) {
    final decrypted = _encryptor.decrypt64(encryptedText, iv: _ivObject);
    return decrypted;
  }

  static Future<bool> setString(String key, String value) {
    return preferences.setString(key, _encryptData(value));
  }

  static Future<bool> setBool(String key, bool value) {
    return preferences.setBool(key, value);
  }

  static Future<bool> setInt(String key, int value) {
    return preferences.setInt(key, value);
  }

  static String? getString(String key) {
    String? data = preferences.getString(key);
    if (data != null) {
      return _decryptData(data);
    }
    return null;
  }

  static int? getInt(String key) {
    return preferences.getInt(key);
  }

  static bool? getBool(String key) {
    return preferences.getBool(key);
  }

  static Future<bool> setStringList(String key, List<String> value) {
    return preferences.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    return preferences.getStringList(key);
  }

  static Future<bool> remove(String key) {
    return preferences.remove(key);
  }

  static Future<bool> clear() {
    return preferences.clear();
  }
}
