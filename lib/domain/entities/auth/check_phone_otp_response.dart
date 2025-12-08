class CheckPhoneOtpResponse {
  final String step;
  final String phoneConfirmationToken;
  final String message;

  CheckPhoneOtpResponse({
    required this.step,
    required this.phoneConfirmationToken,
    required this.message,
  });
}
