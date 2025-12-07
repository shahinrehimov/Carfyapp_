class SimpleMessageModel {
  final String step;
  final String message;

  SimpleMessageModel({required this.step, required this.message});

  factory SimpleMessageModel.fromJson(Map<String, dynamic> json) {
    return SimpleMessageModel(
      step: json['step'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
