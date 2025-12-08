class VersionModel {
  final int langVersion;
  final String defaultLang;

  VersionModel({required this.langVersion, required this.defaultLang});

  factory VersionModel.fromJson(Map<String, dynamic> json) {
    return VersionModel(langVersion: json['lang_version'] as int, defaultLang: json['default_lang'] as String);
  }
}
