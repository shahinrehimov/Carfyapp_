import 'package:carfy/domain/entities/auth/auth_user.dart';
import 'package:carfy/domain/entities/auth/guest_identifier_response.dart';
import 'package:dartz/dartz.dart';

import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/auth/check_email_response.dart';
import 'package:carfy/domain/entities/auth/check_phone_otp_response.dart';
import 'package:carfy/domain/entities/auth/forgot_password_response.dart';
import 'package:carfy/domain/entities/auth/google_auth_redirect.dart';
import 'package:carfy/domain/entities/auth/login_response.dart';
import 'package:carfy/domain/entities/auth/logout_response.dart';
import 'package:carfy/domain/entities/auth/register_email_response.dart';
import 'package:carfy/domain/entities/auth/register_phone_response.dart';
import 'package:carfy/domain/entities/auth/send_phone_otp_response.dart';
import 'package:carfy/domain/entities/auth/verify_otp_response.dart';
import 'package:carfy/domain/params/auth/check_email_params.dart';
import 'package:carfy/domain/params/auth/check_phone_otp_params.dart';
import 'package:carfy/domain/params/auth/forgot_password_params.dart';
import 'package:carfy/domain/params/auth/login_with_email_params.dart';
import 'package:carfy/domain/params/auth/login_with_phone_otp_params.dart';
import 'package:carfy/domain/params/auth/login_with_phone_submit_params.dart';
import 'package:carfy/domain/params/auth/register_with_email_params.dart';
import 'package:carfy/domain/params/auth/register_with_phone_params.dart';
import 'package:carfy/domain/params/auth/send_phone_otp_params.dart';
import 'package:carfy/domain/params/auth/third_party_login_params.dart';
import 'package:carfy/domain/params/auth/verify_email_otp_params.dart';

abstract class AuthRepository {
  Future<Either<Failure, GoogleAuthRedirect>> getGoogleAuthRedirect();

  Future<Either<Failure, CheckEmailResponse>> checkEmail({required CheckEmailParams params});

  Future<Either<Failure, RegisterEmailResponse>> registerWithEmail({required RegisterWithEmailParams params});

  Future<Either<Failure, VerifyOtpResponse>> verifyEmailOtp({required VerifyEmailOtpParams params});

  Future<Either<Failure, SendPhoneOtpResponse>> sendPhoneOtp({required SendPhoneOtpParams params});

  Future<Either<Failure, CheckPhoneOtpResponse>> checkPhoneOtp({required CheckPhoneOtpParams params});

  Future<Either<Failure, RegisterPhoneResponse>> registerWithPhone({required RegisterWithPhoneParams params});

  Future<Either<Failure, LoginResponse>> loginWithEmail({required LoginWithEmailParams params});

  Future<Either<Failure, SendPhoneOtpResponse>> sendPhoneLoginOtp({required LoginWithPhoneOtpParams params});

  Future<Either<Failure, LoginResponse>> loginWithPhone({required LoginWithPhoneSubmitParams params});

  Future<Either<Failure, LoginResponse>> thirdPartyLogin({required ThirdPartyLoginParams params});

  Future<Either<Failure, LogoutResponse>> logout();

  Future<Either<Failure, LogoutResponse>> logoutAll();

  Future<Either<Failure, void>> sendVerificationEmail();

  Future<Either<Failure, ForgotPasswordResponse>> forgotPassword({required ForgotPasswordParams params});

  Future<Either<Failure, GuestIdentifierResponse>> generateGuestIdentifier();

  Future<Either<Failure, AuthUser>> getProfile();
}
