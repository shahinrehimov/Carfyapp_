class CheckoutResultModel {
  final String? message;
  final bool redirect;
  final String? redirectUrl;

  CheckoutResultModel({this.message, required this.redirect, this.redirectUrl});

  factory CheckoutResultModel.fromJson(Map<String, dynamic> json) {
    return CheckoutResultModel(
      message: json['message'] as String?,
      redirect: json['redirect'] as bool? ?? false,
      redirectUrl: json['redirect_url'] as String?,
    );
  }
}
