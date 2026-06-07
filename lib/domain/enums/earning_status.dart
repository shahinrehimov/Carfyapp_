enum EarningStatus {
  pending,
  available,
  refunded,
  cancelled,
  fraudHold;

  static EarningStatus fromString(String value) => switch (value) {
        'pending' => EarningStatus.pending,
        'available' => EarningStatus.available,
        'refunded' => EarningStatus.refunded,
        'cancelled' => EarningStatus.cancelled,
        'fraud_hold' => EarningStatus.fraudHold,
        _ => EarningStatus.pending,
      };
}
