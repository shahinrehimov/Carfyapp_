import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../common/error/failure.dart';
import '../../common/mixin/repository_safe_call_mixin.dart';
import '../../domain/entities/auth/auth_session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_data_source.dart';
import '../dtos/auth/login_request_dto.dart';
import '../mappers/auth_mapper.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl extends AuthRepository with RepositorySafeCallMixin {
  final AuthDataSource _dataSource;
  final AuthMapper _mapper;

  AuthRepositoryImpl(this._dataSource, this._mapper);

  @override
  Future<Either<Failure, AuthSession>> login({required String username, required String password}) {
    final request = LoginRequestDto(username: username, password: password);
    return safeCall(() => _dataSource.login(request).then(_mapper.mapLoginResponse));
  }
}
