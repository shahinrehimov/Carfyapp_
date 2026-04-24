import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/address_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class DeleteAddressUseCase {
  final AddressRepository _repository;

  DeleteAddressUseCase(this._repository);

  Future<Either<Failure, String>> call(int id) {
    return _repository.deleteAddress(id);
  }
}
