import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/address/address.dart';
import 'package:carfy/domain/params/address/update_address_params.dart';
import 'package:carfy/domain/repositories/address_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateAddressUseCase {
  final AddressRepository _repository;

  UpdateAddressUseCase(this._repository);

  Future<Either<Failure, Address>> call(UpdateAddressParams params) {
    return _repository.updateAddress(params);
  }
}
