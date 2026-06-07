enum AttributionStatus {
  pending,
  active,
  fraudBlocked;

  static AttributionStatus fromString(String value) => switch (value) {
        'pending' => AttributionStatus.pending,
        'active' => AttributionStatus.active,
        'fraud_blocked' => AttributionStatus.fraudBlocked,
        _ => AttributionStatus.pending,
      };
}
