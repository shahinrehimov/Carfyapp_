import 'package:carfy/domain/entities/auth/guest_identifier_response.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../common/error/failure.dart';
import '../../common/mixin/repository_safe_call_mixin.dart';

import '../../domain/entities/auth/google_auth_redirect.dart';
import '../../domain/entities/auth/check_email_response.dart';
import '../../domain/entities/auth/register_email_response.dart';
import '../../domain/entities/auth/verify_otp_response.dart';
import '../../domain/entities/auth/send_phone_otp_response.dart';
import '../../domain/entities/auth/check_phone_otp_response.dart';
import '../../domain/entities/auth/register_phone_response.dart';
import '../../domain/entities/auth/login_response.dart';
import '../../domain/entities/auth/logout_response.dart';
import '../../domain/entities/auth/forgot_password_response.dart';

import '../../domain/params/auth/check_email_params.dart';
import '../../domain/params/auth/register_with_email_params.dart';
import '../../domain/params/auth/verify_email_otp_params.dart';
import '../../domain/params/auth/send_phone_otp_params.dart';
import '../../domain/params/auth/check_phone_otp_params.dart';
import '../../domain/params/auth/register_with_phone_params.dart';
import '../../domain/params/auth/login_with_email_params.dart';
import '../../domain/params/auth/login_with_phone_otp_params.dart';
import '../../domain/params/auth/login_with_phone_submit_params.dart';
import '../../domain/params/auth/third_party_login_params.dart';
import '../../domain/params/auth/forgot_password_params.dart';

import '../../domain/repositories/auth_repository.dart';

import '../datasources/auth_remote_data_source.dart';
import '../mappers/auth_mapper.dart';

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

@Injectable(as: AuthRepository)
class AuthRepositoryImpl extends AuthRepository with RepositorySafeCallMixin {
  final AuthRemoteDataSource _dataSource;
  final AuthMapper _mapper;

  AuthRepositoryImpl(this._dataSource, this._mapper);

  @override
  Future<Either<Failure, GoogleAuthRedirect>> getGoogleAuthRedirect() {
    return safeCall(() async {
      final res = await _dataSource.getGoogleAuthRedirect();
      return _mapper.mapGoogleRedirect(res);
    });
  }

  @override
  Future<Either<Failure, CheckEmailResponse>> checkEmail({required CheckEmailParams params}) {
    return safeCall(() async {
      final res = await _dataSource.checkEmail(CheckEmailRequestDto(email: params.email));
      return _mapper.mapCheckEmail(res);
    });
  }

  @override
  Future<Either<Failure, RegisterEmailResponse>> registerWithEmail({required RegisterWithEmailParams params}) {
    return safeCall(() async {
      final res = await _dataSource.registerWithEmail(
        RegisterWithEmailRequestDto(
          deviceType: params.deviceType,
          name: params.name,
          surname: params.surname,
          gender: params.gender,
          birthDate: params.birthDate,
          email: params.email,
          phone: params.phone,
          password: params.password,
          passwordConfirmation: params.passwordConfirmation,
        ),
      );
      return _mapper.mapRegisterEmail(res);
    });
  }

  @override
  Future<Either<Failure, VerifyOtpResponse>> verifyEmailOtp({required VerifyEmailOtpParams params}) {
    return safeCall(() async {
      final res = await _dataSource.verifyEmailOtp(
        VerifyEmailOtpRequestDto(userUuid: params.userUuid, email: params.email, otp: params.otp),
      );
      return _mapper.mapVerifyOtp(res);
    });
  }

  @override
  Future<Either<Failure, SendPhoneOtpResponse>> sendPhoneOtp({required SendPhoneOtpParams params}) {
    return safeCall(() async {
      final res = await _dataSource.sendPhoneOtp(SendPhoneOtpRequestDto(phone: params.phone));
      return _mapper.mapSendPhoneOtp(res);
    });
  }

  @override
  Future<Either<Failure, CheckPhoneOtpResponse>> checkPhoneOtp({required CheckPhoneOtpParams params}) {
    return safeCall(() async {
      final res = await _dataSource.checkPhoneOtp(CheckPhoneOtpRequestDto(phone: params.phone, otp: params.otp));
      return _mapper.mapCheckPhoneOtp(res);
    });
  }

  @override
  Future<Either<Failure, RegisterPhoneResponse>> registerWithPhone({required RegisterWithPhoneParams params}) {
    return safeCall(() async {
      final res = await _dataSource.registerWithPhone(
        RegisterWithPhoneRequestDto(
          name: params.name,
          surname: params.surname,
          gender: params.gender?.name,
          birthDate: params.birthDate != null ? DateFormat('dd.MM.yyyy').format(params.birthDate!) : null,
          email: params.email,
          phone: params.phone,
          phoneConfirmationToken: params.phoneConfirmationToken,
          otp: params.otp,
        ),
      );
      return _mapper.mapRegisterPhone(res);
    });
  }

  @override
  Future<Either<Failure, LoginResponse>> loginWithEmail({required LoginWithEmailParams params}) {
    return safeCall(() async {
      final res = await _dataSource.loginWithEmail(
        LoginWithEmailRequestDto(email: params.email, password: params.password),
      );
      return _mapper.mapLogin(res);
    });
  }

  @override
  Future<Either<Failure, SendPhoneOtpResponse>> sendPhoneLoginOtp({required LoginWithPhoneOtpParams params}) {
    return safeCall(() async {
      final res = await _dataSource.sendPhoneLoginOtp(LoginWithPhoneOtpRequestDto(phone: params.phone));
      return _mapper.mapSendPhoneOtp(res);
    });
  }

  @override
  Future<Either<Failure, LoginResponse>> loginWithPhone({required LoginWithPhoneSubmitParams params}) {
    return safeCall(() async {
      final res = await _dataSource.loginWithPhone(
        LoginWithPhoneSubmitRequestDto(phone: params.phone, otp: params.otp),
      );
      return _mapper.mapLogin(res);
    });
  }

  @override
  Future<Either<Failure, LoginResponse>> thirdPartyLogin({required ThirdPartyLoginParams params}) {
    return safeCall(() async {
      final res = await _dataSource.thirdPartyLogin(
        ThirdPartyLoginRequestDto(deviceType: params.deviceType, provider: params.provider, token: params.token),
      );
      return _mapper.mapLogin(res);
    });
  }

  @override
  Future<Either<Failure, LogoutResponse>> logout() {
    return safeCall(() async {
      final res = await _dataSource.logout();
      return _mapper.mapLogout(res);
    });
  }

  @override
  Future<Either<Failure, LogoutResponse>> logoutAll() {
    return safeCall(() async {
      final res = await _dataSource.logoutAll();
      return _mapper.mapLogout(res);
    });
  }

  @override
  Future<Either<Failure, void>> sendVerificationEmail() {
    return safeCall(() async {
      await _dataSource.sendVerificationEmail();
    });
  }

  @override
  Future<Either<Failure, ForgotPasswordResponse>> forgotPassword({required ForgotPasswordParams params}) {
    return safeCall(() async {
      final res = await _dataSource.forgotPassword(ForgotPasswordRequestDto(email: params.email));
      return _mapper.mapForgotPassword(res);
    });
  }

  @override
  Future<Either<Failure, GuestIdentifierResponse>> generateGuestIdentifier() {
    return safeCall(() async {
      final res = await _dataSource.generateGuestIdentifier();
      return _mapper.mapGuestIdentifier(res);
    });
  }
}
