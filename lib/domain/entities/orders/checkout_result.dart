class CheckoutResult {
  final String? message;
  final bool redirect;
  final String? redirectUrl;

  CheckoutResult({
    this.message,
    required this.redirect,
    this.redirectUrl,
  });

  bool get requiresWebviewPayment => redirect && redirectUrl != null && redirectUrl!.isNotEmpty;
}
