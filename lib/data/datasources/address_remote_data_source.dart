import 'package:carfy/common/constants/endpoint_paths.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/mixin/datasource_mixin.dart';
import 'package:carfy/common/network/network_manager.dart';
import 'package:carfy/data/models/address/address_model.dart';
import 'package:carfy/data/models/address/address_type_model.dart';
import 'package:carfy/data/models/address/city_model.dart';
import 'package:carfy/domain/params/address/add_address_params.dart';
import 'package:carfy/domain/params/address/update_address_params.dart';
import 'package:injectable/injectable.dart';

abstract class AddressRemoteDataSource {
  Future<List<AddressModel>> getAddresses();

  Future<AddressModel> addAddress(AddAddressParams params);

  Future<AddressModel> updateAddress(UpdateAddressParams params);

  Future<String> deleteAddress(int id);

  Future<String> setDefaultAddress(int id);

  Future<List<AddressTypeModel>> getAddressTypes();

  Future<List<CountryModel>> getCountriesWithCities();
}

@Injectable(as: AddressRemoteDataSource)
class AddressRemoteDataSourceImpl extends AddressRemoteDataSource with DataSourceMixin {
  final NetworkManager _networkManager = getIt<NetworkManager>();

  @override
  Future<List<AddressModel>> getAddresses() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.addressesLoad),
      map: (json) =>
          (json['data'] as List<dynamic>).map((e) => AddressModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  @override
  Future<AddressModel> addAddress(AddAddressParams params) {
    return handleResponse(
      () => _networkManager.post(
        EndpointPaths.addressesAdd,
        data: {
          'address_type_id': params.addressTypeId,
          'city_id': params.cityId,
          'address_line_1': params.addressLine1,
          if (params.addressLine2 != null) 'address_line_2': params.addressLine2,
          if (params.latitude != null) 'latitude': params.latitude,
          if (params.longitude != null) 'longitude': params.longitude,
          'phone': params.phone,
        },
      ),
      map: (json) => AddressModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<AddressModel> updateAddress(UpdateAddressParams params) {
    return handleResponse(
      () => _networkManager.post(
        EndpointPaths.addressUpdate(params.addressId),
        data: {
          'address_type_id': params.addressTypeId,
          'city_id': params.cityId,
          'address_line_1': params.addressLine1,
          if (params.addressLine2 != null) 'address_line_2': params.addressLine2,
          if (params.latitude != null) 'latitude': params.latitude,
          if (params.longitude != null) 'longitude': params.longitude,
          'phone': params.phone,
        },
      ),
      map: (json) => AddressModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<String> deleteAddress(int id) {
    return handleResponse(
      () => _networkManager.delete(EndpointPaths.addressDelete(id)),
      map: (json) => json['message'] as String,
    );
  }

  @override
  Future<String> setDefaultAddress(int id) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.addressSetDefault(id)),
      map: (json) => json['message'] as String,
    );
  }

  @override
  Future<List<AddressTypeModel>> getAddressTypes() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.addressTypes),
      map: (json) => (json['data']['address_type'] as List<dynamic>)
          .map((e) => AddressTypeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<List<CountryModel>> getCountriesWithCities() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.countriesWithCities),
      map: (json) => (json['data']['country_and_city'] as List<dynamic>)
          .map((e) => CountryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
