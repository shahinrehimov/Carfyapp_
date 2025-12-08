import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import '../../../common/error/failure.dart';
import '../../entities/auth/register_phone_response.dart';
import '../../params/auth/register_with_phone_params.dart';
import '../../repositories/auth_repository.dart';

@injectable
class RegisterWithPhoneUseCase {
  final AuthRepository _repository;
  RegisterWithPhoneUseCase(this._repository);

  Future<Either<Failure, RegisterPhoneResponse>> call(RegisterWithPhoneParams params) async {
    return await _repository.registerWithPhone(params: params);
  }
}
