import 'package:carfy/data/models/auth/guest_identifier_response_model.dart';
import 'package:carfy/domain/entities/auth/guest_identifier_response.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/auth/auth_user.dart';
import '../../domain/entities/auth/google_auth_redirect.dart';
import '../../domain/entities/auth/check_email_response.dart';
import '../../domain/entities/auth/verify_otp_response.dart';
import '../../domain/entities/auth/send_phone_otp_response.dart';
import '../../domain/entities/auth/check_phone_otp_response.dart';
import '../../domain/entities/auth/register_email_response.dart';
import '../../domain/entities/auth/register_phone_response.dart';
import '../../domain/entities/auth/login_response.dart';
import '../../domain/entities/auth/logout_response.dart';
import '../../domain/entities/auth/forgot_password_response.dart';

import '../models/auth/auth_user_model.dart';
import '../models/auth/google_auth_redirect_model.dart';
import '../models/auth/register_email_response_model.dart';
import '../models/auth/register_phone_response_model.dart';
import '../models/auth/simple_message_model.dart';
import '../models/auth/check_phone_otp_model.dart';
import '../models/auth/login_response_model.dart';
import '../models/auth/logout_response_model.dart';

@injectable
class AuthMapper {
  AuthUser mapUser(AuthUserModel model) => AuthUser(
    uuid: model.uuid,
    email: model.email,
    phone: model.phone,
    name: model.name,
    surname: model.surname,
    gender: model.gender,
    genderLabel: model.genderLabel,
    birthDate: model.birthDate,
    emailIsVerified: model.emailIsVerified,
    phoneIsVerified: model.phoneIsVerified,
    token: model.token,
  );

  GoogleAuthRedirect mapGoogleRedirect(GoogleAuthRedirectModel model) =>
      GoogleAuthRedirect(step: model.step, url: model.url);

  CheckEmailResponse mapCheckEmail(SimpleMessageModel model) =>
      CheckEmailResponse(step: model.step, message: model.message);

  SendPhoneOtpResponse mapSendPhoneOtp(SimpleMessageModel model) =>
      SendPhoneOtpResponse(step: model.step, message: model.message);

  VerifyOtpResponse mapVerifyOtp(SimpleMessageModel model) => VerifyOtpResponse(message: model.message);

  CheckPhoneOtpResponse mapCheckPhoneOtp(CheckPhoneOtpModel model) => CheckPhoneOtpResponse(
    step: model.step,
    phoneConfirmationToken: model.phoneConfirmationToken,
    message: model.message,
  );

  RegisterEmailResponse mapRegisterEmail(RegisterEmailResponseModel model) =>
      RegisterEmailResponse(step: model.step, user: mapUser(model.user), message: model.message);

  RegisterPhoneResponse mapRegisterPhone(RegisterPhoneResponseModel model) =>
      RegisterPhoneResponse(step: model.step, user: mapUser(model.user), message: model.message);

  LoginResponse mapLogin(LoginResponseModel model) => LoginResponse(data: mapUser(model.data), token: model.token);

  LogoutResponse mapLogout(LogoutResponseModel model) => LogoutResponse(code: model.code, message: model.message);

  ForgotPasswordResponse mapForgotPassword(SimpleMessageModel model) =>
      ForgotPasswordResponse(step: model.step, message: model.message);

  GuestIdentifierResponse mapGuestIdentifier(GuestIdentifierResponseModel model) =>
      GuestIdentifierResponse(identifier: model.identifier, message: model.message);
}
