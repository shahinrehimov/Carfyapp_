// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:carfy/common/network/network_manager.dart' as _i597;
import 'package:carfy/data/datasources/auth_data_source.dart' as _i401;
import 'package:carfy/data/mappers/auth_mapper.dart' as _i163;
import 'package:carfy/data/repositories/auth_repository.dart' as _i886;
import 'package:carfy/domain/repositories/auth_repository.dart' as _i655;
import 'package:carfy/domain/use_cases/auth/login_use_case.dart' as _i1048;
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
    gh.singleton<_i597.NetworkManager>(() => _i597.NetworkManager());
    gh.singleton<_i420.MainCubit>(() => _i420.MainCubit());
    gh.factory<_i163.AuthMapper>(() => _i163.AuthMapperImpl());
    gh.factory<_i655.AuthRepository>(
      () => _i886.AuthRepositoryImpl(
        gh<_i401.AuthDataSource>(),
        gh<_i163.AuthMapper>(),
      ),
    );
    gh.factory<_i1048.LoginUseCase>(
      () => _i1048.LoginUseCase(gh<_i655.AuthRepository>()),
    );
    return this;
  }
}
