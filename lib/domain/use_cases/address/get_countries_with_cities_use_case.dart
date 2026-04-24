import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/address/city.dart';
import 'package:carfy/domain/repositories/address_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCountriesWithCitiesUseCase {
  final AddressRepository _repository;

  GetCountriesWithCitiesUseCase(this._repository);

  Future<Either<Failure, List<Country>>> call() {
    return _repository.getCountriesWithCities();
  }
}
