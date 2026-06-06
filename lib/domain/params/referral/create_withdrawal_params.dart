class CreateWithdrawalParams {
  final double amount;
  final String cardLast4;
  final String cardHolderName;

  CreateWithdrawalParams({
    required this.amount,
    required this.cardLast4,
    required this.cardHolderName,
  });
}
