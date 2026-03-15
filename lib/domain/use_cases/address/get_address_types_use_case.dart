import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/address/address_type.dart';
import 'package:carfy/domain/repositories/address_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetAddressTypesUseCase {
  final AddressRepository _repository;

  GetAddressTypesUseCase(this._repository);

  Future<Either<Failure, List<AddressType>>> call() {
    return _repository.getAddressTypes();
  }
}
