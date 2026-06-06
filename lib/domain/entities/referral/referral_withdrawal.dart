class ReferralWithdrawal {
  final int id;
  final double amount;
  final double fee;
  final double netAmount;
  final String cardLast4;
  final String cardHolderName;
  final String status;
  final String? adminNote;
  final String requestedAt;
  final String? processedAt;

  ReferralWithdrawal({
    required this.id,
    required this.amount,
    required this.fee,
    required this.netAmount,
    required this.cardLast4,
    required this.cardHolderName,
    required this.status,
    this.adminNote,
    required this.requestedAt,
    this.processedAt,
  });
}
