class LoginWithEmailRequestDto {
  final String email;
  final String password;
  final String deviceName;

  LoginWithEmailRequestDto({required this.email, required this.password, required this.deviceName});

  Map<String, dynamic> toJson() => {'device_type': deviceName, 'email': email, 'password': password};
}
