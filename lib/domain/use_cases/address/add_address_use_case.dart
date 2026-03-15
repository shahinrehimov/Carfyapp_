import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/address/address.dart';
import 'package:carfy/domain/params/address/add_address_params.dart';
import 'package:carfy/domain/repositories/address_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddAddressUseCase {
  final AddressRepository _repository;

  AddAddressUseCase(this._repository);

  Future<Either<Failure, Address>> call(AddAddressParams params) {
    return _repository.addAddress(params);
  }
}
