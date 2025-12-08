class RegisterWithPhoneParams {
  final String deviceType;
  final String name;
  final String surname;
  final String? gender;
  final String? birthDate;
  final String email;
  final String phone;
  final String phoneConfirmationToken;
  final int otp;

  RegisterWithPhoneParams({
    required this.deviceType,
    required this.name,
    required this.surname,
    this.gender,
    this.birthDate,
    required this.email,
    required this.phone,
    required this.phoneConfirmationToken,
    required this.otp,
  });
}
