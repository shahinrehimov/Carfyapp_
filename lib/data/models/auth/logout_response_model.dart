class LogoutResponseModel {
  final int code;
  final String message;

  LogoutResponseModel({required this.code, required this.message});

  factory LogoutResponseModel.fromJson(Map<String, dynamic> json) {
    return LogoutResponseModel(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}
