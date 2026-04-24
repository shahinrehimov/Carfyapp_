import 'package:carfy/common/error/failure.dart';
import 'package:carfy/common/mixin/repository_safe_call_mixin.dart';
import 'package:carfy/data/datasources/address_remote_data_source.dart';
import 'package:carfy/data/mappers/address_mapper.dart';
import 'package:carfy/domain/entities/address/address.dart';
import 'package:carfy/domain/entities/address/address_type.dart';
import 'package:carfy/domain/entities/address/city.dart';
import 'package:carfy/domain/params/address/add_address_params.dart';
import 'package:carfy/domain/params/address/update_address_params.dart';
import 'package:carfy/domain/repositories/address_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AddressRepository)
class AddressRepositoryImpl extends AddressRepository with RepositorySafeCallMixin {
  final AddressRemoteDataSource _remoteDataSource;
  final AddressMapper _mapper;

  AddressRepositoryImpl(this._remoteDataSource, this._mapper);

  @override
  Future<Either<Failure, List<Address>>> getAddresses() {
    return safeCall(() async {
      final models = await _remoteDataSource.getAddresses();
      return models.map(_mapper.mapAddress).toList();
    });
  }

  @override
  Future<Either<Failure, Address>> addAddress(AddAddressParams params) {
    return safeCall(() async {
      final model = await _remoteDataSource.addAddress(params);
      return _mapper.mapAddress(model);
    });
  }

  @override
  Future<Either<Failure, Address>> updateAddress(UpdateAddressParams params) {
    return safeCall(() async {
      final model = await _remoteDataSource.updateAddress(params);
      return _mapper.mapAddress(model);
    });
  }

  @override
  Future<Either<Failure, String>> deleteAddress(int id) {
    return safeCall(() => _remoteDataSource.deleteAddress(id));
  }

  @override
  Future<Either<Failure, String>> setDefaultAddress(int id) {
    return safeCall(() => _remoteDataSource.setDefaultAddress(id));
  }

  @override
  Future<Either<Failure, List<AddressType>>> getAddressTypes() {
    return safeCall(() async {
      final models = await _remoteDataSource.getAddressTypes();
      return models.map(_mapper.mapAddressType).toList();
    });
  }

  @override
  Future<Either<Failure, List<Country>>> getCountriesWithCities() {
    return safeCall(() async {
      final models = await _remoteDataSource.getCountriesWithCities();
      return models.map(_mapper.mapCountry).toList();
    });
  }
}
