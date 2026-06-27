class ThirdPartyLoginRequestDto {
  final String deviceType;
  final String provider;
  final String token;

  ThirdPartyLoginRequestDto({required this.deviceType, required this.provider, required this.token});

  Map<String, dynamic> toJson() => {'device_type': deviceType, 'provider': provider, 'token': token};
}
