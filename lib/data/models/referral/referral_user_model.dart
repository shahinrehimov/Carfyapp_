class ReferralUserModel {
  final String referredName;
  final String status;
  final String? activatedAt;
  final String joinedAt;

  ReferralUserModel({required this.referredName, required this.status, this.activatedAt, required this.joinedAt});

  factory ReferralUserModel.fromJson(Map<String, dynamic> json) {
    return ReferralUserModel(
      referredName: json['referred_name'] as String,
      status: json['status'] as String,
      activatedAt: json['activated_at'] as String?,
      joinedAt: json['joined_at'] as String,
    );
  }
}
