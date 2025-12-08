class ApiErrorModel {
  final String message;
  final Map<String, List<String>>? errors;

  ApiErrorModel({required this.message, this.errors});

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) {
    return ApiErrorModel(
      message: json['message'] ?? '',
      errors: (json['errors'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, (value as List).map((e) => e.toString()).toList()),
      ),
    );
  }
}
