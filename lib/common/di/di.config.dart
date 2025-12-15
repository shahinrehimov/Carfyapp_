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
import 'package:carfy/data/datasources/category_remote_data_source.dart'
    as _i861;
import 'package:carfy/data/datasources/product_remote_data_source.dart'
    as _i881;
import 'package:carfy/data/datasources/translation_local_data_source.dart'
    as _i1053;
import 'package:carfy/data/datasources/translation_remote_data_source.dart'
    as _i387;
import 'package:carfy/data/datasources/version_remote_data_source.dart'
    as _i713;
import 'package:carfy/data/mappers/auth_mapper.dart' as _i163;
import 'package:carfy/data/mappers/category_mapper.dart' as _i109;
import 'package:carfy/data/mappers/product_mapper.dart' as _i344;
import 'package:carfy/data/repositories/auth_repository_impl.dart' as _i407;
import 'package:carfy/data/repositories/category_repository_impl.dart' as _i395;
import 'package:carfy/data/repositories/product_repository_impl.dart' as _i848;
import 'package:carfy/data/repositories/translations_repository_impl.dart'
    as _i35;
import 'package:carfy/data/repositories/version_repository_impl.dart' as _i235;
import 'package:carfy/domain/repositories/auth_repository.dart' as _i655;
import 'package:carfy/domain/repositories/category_repository.dart' as _i557;
import 'package:carfy/domain/repositories/product_repository.dart' as _i39;
import 'package:carfy/domain/repositories/translation_repository.dart' as _i611;
import 'package:carfy/domain/repositories/version_repository.dart' as _i745;
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
import 'package:carfy/domain/use_cases/category/get_categories_use_case.dart'
    as _i202;
import 'package:carfy/domain/use_cases/product/get_products_use_case.dart'
    as _i603;
import 'package:carfy/domain/use_cases/translations/get_cached_translations_use_case.dart'
    as _i187;
import 'package:carfy/domain/use_cases/translations/get_remote_translations_use_case.dart'
    as _i567;
import 'package:carfy/domain/use_cases/translations/save_translations_use_case.dart'
    as _i740;
import 'package:carfy/domain/use_cases/version/get_versions_use_case.dart'
    as _i450;
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
    gh.factory<_i109.CategoryMapper>(() => _i109.CategoryMapper());
    gh.factory<_i344.ProductMapper>(() => _i344.ProductMapper());
    gh.singleton<_i597.NetworkManager>(() => _i597.NetworkManager());
    gh.singleton<_i420.MainCubit>(() => _i420.MainCubit());
    gh.factory<_i713.VersionRemoteDataSource>(
      () => _i713.VersionRemoteDataSourceImpl(),
    );
    gh.factory<_i881.ProductRemoteDataSource>(
      () => _i881.ProductRemoteDataSourceImpl(),
    );
    gh.factory<_i861.CategoryRemoteDataSource>(
      () => _i861.CategoryRemoteDataSourceImpl(),
    );
    gh.factory<_i1053.TranslationLocalDataSource>(
      () => _i1053.TranslationLocalDataSourceImpl(),
    );
    gh.factory<_i250.AuthRemoteDataSource>(
      () => _i250.AuthRemoteDataSourceImpl(),
    );
    gh.factory<_i387.TranslationRemoteDataSource>(
      () => _i387.TranslationRemoteDataSourceImpl(),
    );
    gh.factory<_i745.VersionRepository>(
      () => _i235.VersionRepositoryImpl(gh<_i713.VersionRemoteDataSource>()),
    );
    gh.factory<_i39.ProductRepository>(
      () => _i848.ProductRepositoryImpl(
        gh<_i881.ProductRemoteDataSource>(),
        gh<_i344.ProductMapper>(),
      ),
    );
    gh.factory<_i557.CategoryRepository>(
      () => _i395.CategoryRepositoryImpl(
        gh<_i861.CategoryRemoteDataSource>(),
        gh<_i109.CategoryMapper>(),
      ),
    );
    gh.factory<_i603.GetProductsUseCase>(
      () => _i603.GetProductsUseCase(gh<_i39.ProductRepository>()),
    );
    gh.factory<_i202.GetCategoriesUseCase>(
      () => _i202.GetCategoriesUseCase(gh<_i557.CategoryRepository>()),
    );
    gh.factory<_i655.AuthRepository>(
      () => _i407.AuthRepositoryImpl(
        gh<_i250.AuthRemoteDataSource>(),
        gh<_i163.AuthMapper>(),
      ),
    );
    gh.factory<_i611.TranslationRepository>(
      () => _i35.TranslationsRepositoryImpl(
        gh<_i387.TranslationRemoteDataSource>(),
        gh<_i1053.TranslationLocalDataSource>(),
      ),
    );
    gh.factory<_i450.GetVersionsUseCase>(
      () => _i450.GetVersionsUseCase(gh<_i745.VersionRepository>()),
    );
    gh.factory<_i581.CheckEmailUseCase>(
      () => _i581.CheckEmailUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i818.CheckPhoneOtpUseCase>(
      () => _i818.CheckPhoneOtpUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i62.ForgotPasswordUseCase>(
      () => _i62.ForgotPasswordUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i593.GenerateGuestIdentifierUseCase>(
      () => _i593.GenerateGuestIdentifierUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i559.GetGoogleAuthRedirectUseCase>(
      () => _i559.GetGoogleAuthRedirectUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i601.LoginWithEmailUseCase>(
      () => _i601.LoginWithEmailUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i963.LoginWithPhoneUseCase>(
      () => _i963.LoginWithPhoneUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i311.LogoutAllUseCase>(
      () => _i311.LogoutAllUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i992.LogoutUseCase>(
      () => _i992.LogoutUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i401.RegisterWithEmailUseCase>(
      () => _i401.RegisterWithEmailUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i71.RegisterWithPhoneUseCase>(
      () => _i71.RegisterWithPhoneUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i90.SendPhoneLoginOtpUseCase>(
      () => _i90.SendPhoneLoginOtpUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i620.SendPhoneRegisterOtpUseCase>(
      () => _i620.SendPhoneRegisterOtpUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i25.SendVerificationEmailUseCase>(
      () => _i25.SendVerificationEmailUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i401.ThirdPartyLoginUseCase>(
      () => _i401.ThirdPartyLoginUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i346.VerifyEmailOtpUseCase>(
      () => _i346.VerifyEmailOtpUseCase(gh<_i655.AuthRepository>()),
    );
    gh.factory<_i187.GetCachedTranslationsUseCase>(
      () =>
          _i187.GetCachedTranslationsUseCase(gh<_i611.TranslationRepository>()),
    );
    gh.factory<_i567.GetRemoteTranslationsUseCase>(
      () =>
          _i567.GetRemoteTranslationsUseCase(gh<_i611.TranslationRepository>()),
    );
    gh.factory<_i740.SaveTranslationsUseCase>(
      () => _i740.SaveTranslationsUseCase(gh<_i611.TranslationRepository>()),
    );
    return this;
  }
}
