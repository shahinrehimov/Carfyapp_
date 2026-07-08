class AppSettingModel {
  final String phone;
  final String email;
  final String iosMinVersion;
  final String androidMinVersion;

  AppSettingModel({
    required this.phone,
    required this.email,
    required this.iosMinVersion,
    required this.androidMinVersion,
  });

  factory AppSettingModel.fromJson(Map<String, dynamic> json) {
    final setting = json['data']['setting'] as Map<String, dynamic>;
    return AppSettingModel(
      phone: setting['phone'] as String? ?? '',
      email: setting['email'] as String? ?? '',
      iosMinVersion: setting['ios_min_version'] as String? ?? '',
      androidMinVersion: setting['android_min_version'] as String? ?? '',
    );
  }
}
