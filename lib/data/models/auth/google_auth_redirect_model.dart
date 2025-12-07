class GoogleAuthRedirectModel {
  final String step;
  final String url;

  GoogleAuthRedirectModel({required this.step, required this.url});

  factory GoogleAuthRedirectModel.fromJson(Map<String, dynamic> json) {
    return GoogleAuthRedirectModel(
      step: json['step'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
