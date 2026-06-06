class ReferralWithdrawalModel {
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

  ReferralWithdrawalModel({
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

  factory ReferralWithdrawalModel.fromJson(Map<String, dynamic> json) {
    return ReferralWithdrawalModel(
      id: json['id'] as int,
      amount: (json['amount'] as num).toDouble(),
      fee: (json['fee'] as num).toDouble(),
      netAmount: (json['net_amount'] as num).toDouble(),
      cardLast4: json['card_last4'] as String,
      cardHolderName: json['card_holder_name'] as String,
      status: json['status'] as String,
      adminNote: json['admin_note'] as String?,
      requestedAt: json['requested_at'] as String,
      processedAt: json['processed_at'] as String?,
    );
  }
}
