import 'package:carfy/common/constants/constants.dart';

class LoginWithPhoneSubmitRequestDto {
  final String phone;
  final int otp;

  LoginWithPhoneSubmitRequestDto({required this.phone, required this.otp});

  Map<String, dynamic> toJson() => {'device_type': Constants.deviceType, 'phone': phone, 'otp': otp};
}
