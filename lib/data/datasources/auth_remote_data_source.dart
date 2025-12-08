import 'package:carfy/common/constants/constants.dart';
import 'package:carfy/data/models/auth/guest_identifier_response_model.dart';
import 'package:injectable/injectable.dart';

import '../../common/error/exceptions.dart';
import '../../common/mixin/datasource_mixin.dart';
import '../../common/network/network_manager.dart';
import '../../common/di/di.dart';

import '../dtos/auth/check_email_request_dto.dart';
import '../dtos/auth/register_with_email_request_dto.dart';
import '../dtos/auth/verify_email_otp_request_dto.dart';
import '../dtos/auth/send_phone_otp_request_dto.dart';
import '../dtos/auth/check_phone_otp_request_dto.dart';
import '../dtos/auth/register_with_phone_request_dto.dart';
import '../dtos/auth/login_with_email_request_dto.dart';
import '../dtos/auth/login_with_phone_otp_request_dto.dart';
import '../dtos/auth/login_with_phone_submit_request_dto.dart';
import '../dtos/auth/third_party_login_request_dto.dart';
import '../dtos/auth/reset_password_request_dto.dart';
import '../dtos/auth/forgot_password_request_dto.dart';

import '../models/auth/google_auth_redirect_model.dart';
import '../models/auth/register_email_response_model.dart';
import '../models/auth/register_phone_response_model.dart';
import '../models/auth/simple_message_model.dart';
import '../models/auth/check_phone_otp_model.dart';
import '../models/auth/login_response_model.dart';
import '../models/auth/logout_response_model.dart';

import '../../common/constants/endpoint_paths.dart';

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

  Future<LoginResponseModel> thirdPartyLogin(ThirdPartyLoginRequestDto dto);

  Future<LogoutResponseModel> logout();

  Future<LogoutResponseModel> logoutAll();

  Future<void> sendVerificationEmail();

  Future<SimpleMessageModel> forgotPassword(ForgotPasswordRequestDto dto);

  Future<void> resetPassword(ResetPasswordRequestDto dto);

  Future<GuestIdentifierResponseModel> generateGuestIdentifier();
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
  Future<SimpleMessageModel> checkEmail(CheckEmailRequestDto dto) {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.registerCheckEmail, queryParams: {'email': dto.email}),
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
  Future<SimpleMessageModel> sendPhoneOtp(SendPhoneOtpRequestDto dto) {
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
  Future<RegisterPhoneResponseModel> registerWithPhone(RegisterWithPhoneRequestDto dto) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.registerWithPhone, data: dto.toJson()),
      map: (json) => RegisterPhoneResponseModel.fromJson(json),
    );
  }

  @override
  Future<LoginResponseModel> loginWithEmail(LoginWithEmailRequestDto dto) async {
    try {
      final response = await _networkManager.post(EndpointPaths.loginWithEmail, data: dto.toJson());
      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        throw UserException(message: response.data['message']);
      } else if (response.statusCode == 422) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('errors')) {
          final errors = Map<String, List<String>>.from(
            (data['errors'] as Map).map((key, value) => MapEntry(key.toString(), List<String>.from(value))),
          );
          throw ValidationException(errors);
        }
        throw ServerException();
      }
      throw ServerException();
    } on Exception catch (e) {
      throw handleException(e);
    }
  }

  @override
  Future<SimpleMessageModel> sendPhoneLoginOtp(LoginWithPhoneOtpRequestDto dto) async {
    try {
      final response = await _networkManager.post(EndpointPaths.loginSendPhoneOtp, data: dto.toJson());
      if (response.statusCode == 200) {
        return SimpleMessageModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        throw UserException(message: response.data['message']);
      } else if (response.statusCode == 422) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('errors')) {
          final errors = Map<String, List<String>>.from(
            (data['errors'] as Map).map((key, value) => MapEntry(key.toString(), List<String>.from(value))),
          );
          throw ValidationException(errors);
        }
        throw ServerException();
      }
      throw ServerException();
    } on Exception catch (e) {
      throw handleException(e);
    }
  }

  @override
  Future<LoginResponseModel> loginWithPhone(LoginWithPhoneSubmitRequestDto dto) async {
    try {
      final response = await _networkManager.post(EndpointPaths.loginWithPhone, data: dto.toJson());
      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(response.data);
      } else if (response.statusCode == 400) {
        throw UserException(message: response.data['message']);
      }
      throw ServerException();
    } on Exception catch (e) {
      throw handleException(e);
    }
  }

  @override
  Future<LoginResponseModel> thirdPartyLogin(ThirdPartyLoginRequestDto dto) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.thirdPartyLogin, data: dto.toJson()),
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
  Future<void> sendVerificationEmail() {
    return handleResponse(() => _networkManager.post(EndpointPaths.sendVerificationEmail));
  }

  @override
  Future<SimpleMessageModel> forgotPassword(ForgotPasswordRequestDto dto) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.forgotPassword, data: dto.toJson()),
      map: (json) => SimpleMessageModel.fromJson(json),
    );
  }

  @override
  Future<void> resetPassword(ResetPasswordRequestDto dto) {
    return handleResponse(() => _networkManager.post(EndpointPaths.resetPassword, data: dto.toJson()));
  }

  @override
  Future<GuestIdentifierResponseModel> generateGuestIdentifier() {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.generateIdentifier, data: {'device_type': Constants.deviceType}),
      map: (json) => GuestIdentifierResponseModel.fromJson(json),
    );
  }
}
