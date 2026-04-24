class RegisterWithPhoneRequestDto {
  final String name;
  final String surname;
  final String? gender;
  final String? birthDate;
  final String email;
  final String phone;
  final String phoneConfirmationToken;
  final int otp;
  final String deviceName;

  RegisterWithPhoneRequestDto({
    required this.name,
    required this.surname,
    this.gender,
    this.birthDate,
    required this.email,
    required this.phone,
    required this.phoneConfirmationToken,
    required this.otp,
    required this.deviceName,
  });

  Map<String, dynamic> toJson() => {
    'device_type': deviceName,
    'name': name,
    'surname': surname,
    'gender': gender,
    'birth_date': birthDate,
    'email': email,
    'phone': phone,
    'phone_confirmation_token': phoneConfirmationToken,
    'otp': otp,
  };
}
