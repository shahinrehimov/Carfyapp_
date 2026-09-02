import 'package:carfy/data/models/auth/change_contact_otp_response_model.dart';
import 'package:carfy/data/models/auth/change_contact_verify_response_model.dart';
import 'package:carfy/data/models/auth/guest_identifier_response_model.dart';
import 'package:carfy/data/models/auth/session_model.dart';
import 'package:carfy/data/models/auth/sessions_response_model.dart';
import 'package:carfy/domain/entities/auth/change_contact_otp_response.dart';
import 'package:carfy/domain/entities/auth/guest_identifier_response.dart';
import 'package:carfy/domain/entities/auth/session.dart';
import 'package:carfy/domain/entities/auth/sessions_response.dart';
import 'package:injectable/injectable.dart';

import 'package:carfy/domain/entities/auth/auth_user.dart';
import 'package:carfy/domain/entities/auth/google_auth_redirect.dart';
import 'package:carfy/domain/entities/auth/check_email_response.dart';
import 'package:carfy/domain/entities/auth/verify_otp_response.dart';
import 'package:carfy/domain/entities/auth/send_phone_otp_response.dart';
import 'package:carfy/domain/entities/auth/check_phone_otp_response.dart';
import 'package:carfy/domain/entities/auth/register_email_response.dart';
import 'package:carfy/domain/entities/auth/register_phone_response.dart';
import 'package:carfy/domain/entities/auth/login_response.dart';
import 'package:carfy/domain/entities/auth/logout_response.dart';
import 'package:carfy/domain/entities/auth/forgot_password_response.dart';

import 'package:carfy/data/models/auth/auth_user_model.dart';
import 'package:carfy/data/models/auth/google_auth_redirect_model.dart';
import 'package:carfy/data/models/auth/register_email_response_model.dart';
import 'package:carfy/data/models/auth/register_phone_response_model.dart';
import 'package:carfy/data/models/auth/simple_message_model.dart';
import 'package:carfy/data/models/auth/check_phone_otp_model.dart';
import 'package:carfy/data/models/auth/login_response_model.dart';
import 'package:carfy/data/models/auth/logout_response_model.dart';

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
    image: model.image,
    registerType: model.registerType,
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

  Session mapSession(SessionModel model) => Session(
    id: model.id,
    deviceName: model.deviceName,
    ipAddress: model.ipAddress,
    location: model.location,
    createdAt: model.createdAt,
    isCurrent: model.isCurrent,
  );

  SessionsResponse mapSessions(SessionsResponseModel model) => SessionsResponse(
    currentSession: mapSession(model.currentSession),
    otherSessions: model.otherSessions.map(mapSession).toList(),
  );

  ChangeContactOtpResponse mapChangeContactOtp(ChangeContactOtpResponseModel model) =>
      ChangeContactOtpResponse(message: model.message, otpExpiresIn: model.otpExpiresIn);

  AuthUser mapChangeContactVerify(ChangeContactVerifyResponseModel model) => mapUser(model.user);
}
