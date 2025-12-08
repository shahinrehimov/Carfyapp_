class TranslationModel {
  final Map<String, String> translations;

  TranslationModel({required this.translations});

  factory TranslationModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    return TranslationModel(translations: Map<String, String>.from(data['translations'] as Map? ?? {}));
  }
}
