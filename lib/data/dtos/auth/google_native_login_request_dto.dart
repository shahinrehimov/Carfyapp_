class GoogleNativeLoginRequestDto {
  final String idToken;
  final String deviceType;
  final String refCode;

  GoogleNativeLoginRequestDto({
    required this.idToken,
    required this.deviceType,
    this.refCode = '',
  });

  Map<String, dynamic> toJson() => {
    'id_token': idToken,
    'device_type': deviceType,
    'ref_code': refCode,
  };
}
