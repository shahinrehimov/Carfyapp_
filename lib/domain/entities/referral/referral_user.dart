class ReferralUser {
  final String referredName;
  final String status;
  final String? activatedAt;
  final String joinedAt;

  ReferralUser({
    required this.referredName,
    required this.status,
    this.activatedAt,
    required this.joinedAt,
  });
}
