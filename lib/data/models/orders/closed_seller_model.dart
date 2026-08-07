class ClosedSellerModel {
  final int companyId;
  final String storeCode;
  final String? opensAt;
  final String? message;

  ClosedSellerModel({required this.companyId, required this.storeCode, this.opensAt, this.message});

  factory ClosedSellerModel.fromJson(Map<String, dynamic> json) {
    return ClosedSellerModel(
      companyId: json['company_id'] as int,
      storeCode: json['store_code'] as String,
      opensAt: json['opens_at'] as String?,
      message: json['message'] as String?,
    );
  }
}
