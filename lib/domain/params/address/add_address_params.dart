class AddAddressParams {
  final int addressTypeId;
  final int cityId;
  final String addressLine1;
  final String? addressLine2;
  final String? latitude;
  final String? longitude;
  final String phone;

  AddAddressParams({
    required this.addressTypeId,
    required this.cityId,
    required this.addressLine1,
    this.addressLine2,
    this.latitude,
    this.longitude,
    required this.phone,
  });
}
