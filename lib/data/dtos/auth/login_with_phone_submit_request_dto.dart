class LoginWithPhoneSubmitRequestDto {
  final String phone;
  final int otp;
  final String deviceName;

  LoginWithPhoneSubmitRequestDto({required this.phone, required this.otp, required this.deviceName});

  Map<String, dynamic> toJson() => {'device_type': deviceName, 'phone': phone, 'otp': otp};
}
