import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceUtil {
  static Future<String> getDeviceName() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      return '${info.brand} ${info.model}';
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      return info.name;
    }
    return Platform.operatingSystem;
  }
}
