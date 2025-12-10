import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import '../../../common/error/failure.dart';
import '../../entities/auth/login_response.dart';
import '../../params/auth/third_party_login_params.dart';
import '../../repositories/auth_repository.dart';

@injectable
class ThirdPartyLoginUseCase {
  final AuthRepository _repository;
  ThirdPartyLoginUseCase(this._repository);

  Future<Either<Failure, LoginResponse>> call(ThirdPartyLoginParams params) async {
    return await _repository.thirdPartyLogin(params: params);
  }
}
