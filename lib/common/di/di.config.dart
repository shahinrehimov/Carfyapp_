// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:carfy/common/network/network_manager.dart' as _i597;
import 'package:carfy/data/datasources/auth_remote_data_source.dart' as _i250;
import 'package:carfy/data/mappers/auth_mapper.dart' as _i163;
import 'package:carfy/data/repositories/auth_repository_impl.dart' as _i407;
import 'package:carfy/domain/repositories/auth/auth_repository.dart' as _i658;
import 'package:carfy/domain/use_cases/auth/check_email_use_case.dart' as _i581;
import 'package:carfy/domain/use_cases/auth/check_phone_otp_use_case.dart'
    as _i818;
import 'package:carfy/domain/use_cases/auth/forgot_password_use_case.dart'
    as _i62;
import 'package:carfy/domain/use_cases/auth/generate_guest_identifier_use_case.dart'
    as _i593;
import 'package:carfy/domain/use_cases/auth/get_google_auth_redirect_use_case.dart'
    as _i559;
import 'package:carfy/domain/use_cases/auth/login_with_email_use_case.dart'
    as _i601;
import 'package:carfy/domain/use_cases/auth/login_with_phone_use_case.dart'
    as _i963;
import 'package:carfy/domain/use_cases/auth/logout_all_use_case.dart' as _i311;
import 'package:carfy/domain/use_cases/auth/logout_use_case.dart' as _i992;
import 'package:carfy/domain/use_cases/auth/register_with_email_use_case.dart'
    as _i401;
import 'package:carfy/domain/use_cases/auth/register_with_phone_use_case.dart'
    as _i71;
import 'package:carfy/domain/use_cases/auth/reset_password_use_case.dart'
    as _i576;
import 'package:carfy/domain/use_cases/auth/send_phone_login_otp_use_case.dart'
    as _i90;
import 'package:carfy/domain/use_cases/auth/send_phone_otp_use_case.dart'
    as _i620;
import 'package:carfy/domain/use_cases/auth/send_verification_email_use_case.dart'
    as _i25;
import 'package:carfy/domain/use_cases/auth/third_party_login_use_case.dart'
    as _i401;
import 'package:carfy/domain/use_cases/auth/verify_email_otp_use_case.dart'
    as _i346;
import 'package:carfy/presentation/main/state/main_cubit.dart' as _i420;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i163.AuthMapper>(() => _i163.AuthMapper());
    gh.singleton<_i597.NetworkManager>(() => _i597.NetworkManager());
    gh.singleton<_i420.MainCubit>(() => _i420.MainCubit());
    gh.factory<_i250.AuthRemoteDataSource>(
      () => _i250.AuthRemoteDataSourceImpl(),
    );
    gh.factory<_i658.AuthRepository>(
      () => _i407.AuthRepositoryImpl(
        gh<_i250.AuthRemoteDataSource>(),
        gh<_i163.AuthMapper>(),
      ),
    );
    gh.factory<_i581.CheckEmailUseCase>(
      () => _i581.CheckEmailUseCase(gh<_i658.AuthRepository>()),
    );
    gh.factory<_i818.CheckPhoneOtpUseCase>(
      () => _i818.CheckPhoneOtpUseCase(gh<_i658.AuthRepository>()),
    );
    gh.factory<_i62.ForgotPasswordUseCase>(
      () => _i62.ForgotPasswordUseCase(gh<_i658.AuthRepository>()),
    );
    gh.factory<_i593.GenerateGuestIdentifierUseCase>(
      () => _i593.GenerateGuestIdentifierUseCase(gh<_i658.AuthRepository>()),
    );
    gh.factory<_i559.GetGoogleAuthRedirectUseCase>(
      () => _i559.GetGoogleAuthRedirectUseCase(gh<_i658.AuthRepository>()),
    );
    gh.factory<_i601.LoginWithEmailUseCase>(
      () => _i601.LoginWithEmailUseCase(gh<_i658.AuthRepository>()),
    );
    gh.factory<_i963.LoginWithPhoneUseCase>(
      () => _i963.LoginWithPhoneUseCase(gh<_i658.AuthRepository>()),
    );
    gh.factory<_i311.LogoutAllUseCase>(
      () => _i311.LogoutAllUseCase(gh<_i658.AuthRepository>()),
    );
    gh.factory<_i992.LogoutUseCase>(
      () => _i992.LogoutUseCase(gh<_i658.AuthRepository>()),
    );
    gh.factory<_i401.RegisterWithEmailUseCase>(
      () => _i401.RegisterWithEmailUseCase(gh<_i658.AuthRepository>()),
    );
    gh.factory<_i71.RegisterWithPhoneUseCase>(
      () => _i71.RegisterWithPhoneUseCase(gh<_i658.AuthRepository>()),
    );
    gh.factory<_i576.ResetPasswordUseCase>(
      () => _i576.ResetPasswordUseCase(gh<_i658.AuthRepository>()),
    );
    gh.factory<_i90.SendPhoneLoginOtpUseCase>(
      () => _i90.SendPhoneLoginOtpUseCase(gh<_i658.AuthRepository>()),
    );
    gh.factory<_i620.SendPhoneOtpUseCase>(
      () => _i620.SendPhoneOtpUseCase(gh<_i658.AuthRepository>()),
    );
    gh.factory<_i25.SendVerificationEmailUseCase>(
      () => _i25.SendVerificationEmailUseCase(gh<_i658.AuthRepository>()),
    );
    gh.factory<_i401.ThirdPartyLoginUseCase>(
      () => _i401.ThirdPartyLoginUseCase(gh<_i658.AuthRepository>()),
    );
    gh.factory<_i346.VerifyEmailOtpUseCase>(
      () => _i346.VerifyEmailOtpUseCase(gh<_i658.AuthRepository>()),
    );
    return this;
  }
}
