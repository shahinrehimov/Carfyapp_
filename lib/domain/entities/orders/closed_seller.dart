class ClosedSeller {
  final int companyId;
  final String storeCode;
  final String? opensAt;
  final String? message;

  ClosedSeller({required this.companyId, required this.storeCode, this.opensAt, this.message});
}
