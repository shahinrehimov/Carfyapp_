import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/address/address.dart';
import 'package:carfy/domain/entities/address/address_type.dart';
import 'package:carfy/domain/entities/address/city.dart';
import 'package:carfy/domain/params/address/add_address_params.dart';
import 'package:carfy/domain/params/address/update_address_params.dart';
import 'package:dartz/dartz.dart';

abstract class AddressRepository {
  Future<Either<Failure, List<Address>>> getAddresses();
  Future<Either<Failure, Address>> addAddress(AddAddressParams params);
  Future<Either<Failure, Address>> updateAddress(UpdateAddressParams params);
  Future<Either<Failure, String>> deleteAddress(int id);
  Future<Either<Failure, String>> setDefaultAddress(int id);
  Future<Either<Failure, List<AddressType>>> getAddressTypes();
  Future<Either<Failure, List<Country>>> getCountriesWithCities();
}
