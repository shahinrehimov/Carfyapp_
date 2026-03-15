import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/address/address.dart';
import 'package:carfy/domain/repositories/address_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAddressesUseCase {
  final AddressRepository _repository;

  GetAddressesUseCase(this._repository);

  Future<Either<Failure, List<Address>>> call() {
    return _repository.getAddresses();
  }
}
