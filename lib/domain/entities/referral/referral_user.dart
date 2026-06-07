import 'package:carfy/domain/enums/attribution_status.dart';

class ReferralUser {
  final String referredName;
  final AttributionStatus status;
  final String? activatedAt;
  final String joinedAt;

  ReferralUser({
    required this.referredName,
    required this.status,
    this.activatedAt,
    required this.joinedAt,
  });
}
