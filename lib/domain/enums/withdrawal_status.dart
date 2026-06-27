enum WithdrawalStatus {
  pending,
  approved,
  paid,
  rejected;

  static WithdrawalStatus fromString(String value) => switch (value) {
    'pending' => WithdrawalStatus.pending,
    'approved' => WithdrawalStatus.approved,
    'paid' => WithdrawalStatus.paid,
    'rejected' => WithdrawalStatus.rejected,
    _ => WithdrawalStatus.pending,
  };
}
