class AppLanguageModel {
  final int id;
  final String key;

  AppLanguageModel({required this.id, required this.key});

  factory AppLanguageModel.fromJson(Map<String, dynamic> json) {
    return AppLanguageModel(
      id: json['id'] as int,
      key: json['key'] as String,
    );
  }
}
