import 'package:carfy/data/models/address/address_model.dart';
import 'package:carfy/data/models/address/address_type_model.dart';
import 'package:carfy/data/models/address/city_model.dart';
import 'package:carfy/domain/entities/address/address.dart';
import 'package:carfy/domain/entities/address/address_type.dart';
import 'package:carfy/domain/entities/address/city.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddressMapper {
  AddressType mapAddressType(AddressTypeModel model) => AddressType(id: model.id, title: model.title);

  City mapCity(CityModel model) => City(id: model.id, title: model.title, countryId: model.countryId);

  Country mapCountry(CountryModel model) =>
      Country(id: model.id, title: model.title, cities: model.cities.map(mapCity).toList());

  Address mapAddress(AddressModel model) => Address(
    id: model.id,
    isDefault: model.isDefault,
    addressType: AddressType(id: model.addressType.id, title: model.addressType.title),
    city: AddressCity(
      id: model.city.id,
      title: model.city.title,
      countryId: model.city.countryId,
      countryTitle: model.city.countryTitle,
    ),
    addressLine1: model.addressLine1,
    addressLine2: model.addressLine2,
    latitude: model.latitude,
    longitude: model.longitude,
    phone: model.phone,
  );
}
