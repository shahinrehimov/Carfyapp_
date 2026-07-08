class AppleNativeLoginRequestDto {
  final String identityToken;
  final String? authorizationCode;
  final String? name;
  final String? surname;
  final String deviceType;
  final String refCode;

  AppleNativeLoginRequestDto({
    required this.identityToken,
    this.authorizationCode,
    this.name,
    this.surname,
    this.deviceType = 'ios',
    this.refCode = '',
  });

  Map<String, dynamic> toJson() => {
    'identity_token': identityToken,
    if (authorizationCode != null) 'authorization_code': authorizationCode,
    if (name != null) 'name': name,
    if (surname != null) 'surname': surname,
    'device_type': deviceType,
    'ref_code': refCode,
  };
}
