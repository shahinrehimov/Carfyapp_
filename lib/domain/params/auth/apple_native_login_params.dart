class AppleNativeLoginParams {
  final String identityToken;
  final String? authorizationCode;
  final String? name;
  final String? surname;

  AppleNativeLoginParams({
    required this.identityToken,
    this.authorizationCode,
    this.name,
    this.surname,
  });
}
