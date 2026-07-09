import 'dart:io';

import 'package:carfy/data/models/auth/guest_identifier_response_model.dart';
import 'package:injectable/injectable.dart';

import 'package:carfy/common/mixin/datasource_mixin.dart';
import 'package:carfy/common/network/network_manager.dart';
import 'package:carfy/common/di/di.dart';

import 'package:carfy/data/dtos/auth/check_email_request_dto.dart';
import 'package:carfy/data/dtos/auth/register_with_email_request_dto.dart';
import 'package:carfy/data/dtos/auth/verify_email_otp_request_dto.dart';
import 'package:carfy/data/dtos/auth/send_phone_otp_request_dto.dart';
import 'package:carfy/data/dtos/auth/check_phone_otp_request_dto.dart';
import 'package:carfy/data/dtos/auth/register_with_phone_request_dto.dart';
import 'package:carfy/data/dtos/auth/login_with_email_request_dto.dart';
import 'package:carfy/data/dtos/auth/login_with_phone_otp_request_dto.dart';
import 'package:carfy/data/dtos/auth/login_with_phone_submit_request_dto.dart';
import 'package:carfy/data/dtos/auth/apple_native_login_request_dto.dart';
import 'package:carfy/data/dtos/auth/google_native_login_request_dto.dart';
import 'package:carfy/data/dtos/auth/forgot_password_request_dto.dart';
import 'package:carfy/data/dtos/auth/update_profile_request_dto.dart';

import 'package:carfy/data/models/auth/auth_user_model.dart';
import 'package:carfy/data/models/auth/google_auth_redirect_model.dart';
import 'package:carfy/data/models/auth/register_email_response_model.dart';
import 'package:carfy/data/models/auth/register_phone_response_model.dart';
import 'package:carfy/data/models/auth/simple_message_model.dart';
import 'package:carfy/data/models/auth/check_phone_otp_model.dart';
import 'package:carfy/data/models/auth/login_response_model.dart';
import 'package:carfy/data/models/auth/logout_response_model.dart';
import 'package:carfy/data/models/auth/sessions_response_model.dart';

import 'package:carfy/common/constants/endpoint_paths.dart';

abstract class AuthRemoteDataSource {
  Future<GoogleAuthRedirectModel> getGoogleAuthRedirect();

  Future<SimpleMessageModel> checkEmail(CheckEmailRequestDto dto);

  Future<RegisterEmailResponseModel> registerWithEmail(RegisterWithEmailRequestDto dto);

  Future<SimpleMessageModel> verifyEmailOtp(VerifyEmailOtpRequestDto dto);

  Future<SimpleMessageModel> sendPhoneOtp(SendPhoneOtpRequestDto dto);

  Future<CheckPhoneOtpModel> checkPhoneOtp(CheckPhoneOtpRequestDto dto);

  Future<RegisterPhoneResponseModel> registerWithPhone(RegisterWithPhoneRequestDto dto);

  Future<LoginResponseModel> loginWithEmail(LoginWithEmailRequestDto dto);

  Future<SimpleMessageModel> sendPhoneLoginOtp(LoginWithPhoneOtpRequestDto dto);

  Future<LoginResponseModel> loginWithPhone(LoginWithPhoneSubmitRequestDto dto);

  Future<LoginResponseModel> appleNativeLogin(AppleNativeLoginRequestDto dto);

  Future<LoginResponseModel> googleNativeLogin(GoogleNativeLoginRequestDto dto);

  Future<LogoutResponseModel> logout();

  Future<LogoutResponseModel> logoutAll();

  Future<LogoutResponseModel> deleteAccount();

  Future<void> sendVerificationEmail();

  Future<SimpleMessageModel> forgotPassword(ForgotPasswordRequestDto dto);

  Future<GuestIdentifierResponseModel> generateGuestIdentifier();

  Future<AuthUserModel> getProfile();

  Future<AuthUserModel> updateProfile(UpdateProfileRequestDto dto);

  Future<SessionsResponseModel> getSessions();

  Future<String> logoutSession(int tokenId);
}

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl extends AuthRemoteDataSource with DataSourceMixin {
  final NetworkManager _networkManager = getIt<NetworkManager>();

  @override
  Future<GoogleAuthRedirectModel> getGoogleAuthRedirect() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.getGoogleRedirect),
      map: (json) => GoogleAuthRedirectModel.fromJson(json),
    );
  }

  @override
  Future<SimpleMessageModel> checkEmail(CheckEmailRequestDto dto) async {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.registerCheckEmail, queryParams: dto.toJson()),
      map: (json) => SimpleMessageModel.fromJson(json),
    );
  }

  @override
  Future<RegisterEmailResponseModel> registerWithEmail(RegisterWithEmailRequestDto dto) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.registerWithEmail, data: dto.toJson()),
      map: (json) => RegisterEmailResponseModel.fromJson(json),
    );
  }

  @override
  Future<SimpleMessageModel> verifyEmailOtp(VerifyEmailOtpRequestDto dto) {
    return handleResponse(
      () => _networkManager.post('${EndpointPaths.registerVerifyEmailOtp}/${dto.userUuid}', data: dto.toJson()),
      map: (json) => SimpleMessageModel.fromJson(json),
    );
  }

  @override
  Future<SimpleMessageModel> sendPhoneOtp(SendPhoneOtpRequestDto dto) async {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.registerSendPhoneOtp, data: dto.toJson()),
      map: (json) => SimpleMessageModel.fromJson(json),
    );
  }

  @override
  Future<CheckPhoneOtpModel> checkPhoneOtp(CheckPhoneOtpRequestDto dto) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.registerCheckPhoneOtp, data: dto.toJson()),
      map: (json) => CheckPhoneOtpModel.fromJson(json),
    );
  }

  @override
  Future<RegisterPhoneResponseModel> registerWithPhone(RegisterWithPhoneRequestDto dto) async {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.registerWithPhone, data: dto.toJson()),
      map: (json) => RegisterPhoneResponseModel.fromJson(json),
    );
  }

  @override
  Future<LoginResponseModel> loginWithEmail(LoginWithEmailRequestDto dto) async {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.loginWithEmail, data: dto.toJson()),
      map: (json) => LoginResponseModel.fromJson(json),
    );
  }

  @override
  Future<SimpleMessageModel> sendPhoneLoginOtp(LoginWithPhoneOtpRequestDto dto) async {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.loginSendPhoneOtp, data: dto.toJson()),
      map: (json) => SimpleMessageModel.fromJson(json),
    );
  }

  @override
  Future<LoginResponseModel> loginWithPhone(LoginWithPhoneSubmitRequestDto dto) async {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.loginWithPhone, data: dto.toJson()),
      map: (json) => LoginResponseModel.fromJson(json),
    );
  }

  @override
  Future<LoginResponseModel> googleNativeLogin(GoogleNativeLoginRequestDto dto) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.googleNativeLogin, data: dto.toJson()),
      map: (json) => LoginResponseModel.fromJson(json),
    );
  }

  @override
  Future<LoginResponseModel> appleNativeLogin(AppleNativeLoginRequestDto dto) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.appleNativeLogin, data: dto.toJson()),
      map: (json) => LoginResponseModel.fromJson(json),
    );
  }

  @override
  Future<LogoutResponseModel> logout() {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.logout),
      map: (json) => LogoutResponseModel.fromJson(json),
    );
  }

  @override
  Future<LogoutResponseModel> logoutAll() {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.logoutAll),
      map: (json) => LogoutResponseModel.fromJson(json),
    );
  }

  @override
  Future<LogoutResponseModel> deleteAccount() {
    return handleResponse(
      () => _networkManager.delete(EndpointPaths.deleteAccount),
      map: (json) => LogoutResponseModel.fromJson(json),
    );
  }

  @override
  Future<void> sendVerificationEmail() {
    return handleResponse(() => _networkManager.post(EndpointPaths.sendVerificationEmail));
  }

  @override
  Future<SimpleMessageModel> forgotPassword(ForgotPasswordRequestDto dto) async {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.forgotPassword, data: dto.toJson()),
      map: (json) => SimpleMessageModel.fromJson(json),
    );
  }

  @override
  Future<GuestIdentifierResponseModel> generateGuestIdentifier() {
    return handleResponse(
      () => _networkManager.post(
        EndpointPaths.generateIdentifier,
        data: {'device_type': Platform.isAndroid ? 'android' : 'ios'},
      ),
      map: (json) => GuestIdentifierResponseModel.fromJson(json),
    );
  }

  @override
  Future<AuthUserModel> getProfile() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.profileMe),
      map: (json) => AuthUserModel.fromJson(json['data']),
    );
  }

  @override
  Future<AuthUserModel> updateProfile(UpdateProfileRequestDto dto) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.profileUpdate, data: dto.toJson()),
      map: (json) => AuthUserModel.fromJson(json['user']),
    );
  }

  @override
  Future<SessionsResponseModel> getSessions() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.sessionsLoad),
      map: (json) => SessionsResponseModel.fromJson(json),
    );
  }

  @override
  Future<String> logoutSession(int tokenId) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.sessionLogout(tokenId)),
      map: (json) => json['message'] as String? ?? '',
    );
  }
}
