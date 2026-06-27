import 'package:carfy/data/models/address/address_type_model.dart';

class AddressCityModel {
  final int id;
  final String title;
  final int countryId;
  final String countryTitle;

  AddressCityModel({required this.id, required this.title, required this.countryId, required this.countryTitle});

  factory AddressCityModel.fromJson(Map<String, dynamic> json) {
    final country = json['country'] as Map<String, dynamic>? ?? {};
    return AddressCityModel(
      id: json['id'] as int,
      title: json['title'] as String,
      countryId: json['country_id'] as int,
      countryTitle: country['title'] as String? ?? '',
    );
  }
}

class AddressModel {
  final int id;
  final bool isDefault;
  final AddressTypeModel addressType;
  final AddressCityModel city;
  final String addressLine1;
  final String? addressLine2;
  final String? latitude;
  final String? longitude;
  final String phone;

  AddressModel({
    required this.id,
    required this.isDefault,
    required this.addressType,
    required this.city,
    required this.addressLine1,
    this.addressLine2,
    this.latitude,
    this.longitude,
    required this.phone,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    id: json['id'] as int,
    isDefault: json['is_default'] as bool,
    addressType: AddressTypeModel.fromJson(json['address_type'] as Map<String, dynamic>),
    city: AddressCityModel.fromJson(json['city'] as Map<String, dynamic>),
    addressLine1: json['address_line_1'] as String,
    addressLine2: json['address_line_2'] as String?,
    latitude: json['latitude'] as String?,
    longitude: json['longitude'] as String?,
    phone: json['phone'] as String,
  );
}
