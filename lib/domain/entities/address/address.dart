import 'package:carfy/domain/entities/address/address_type.dart';

class AddressCity {
  final int id;
  final String title;
  final int countryId;
  final String countryTitle;

  AddressCity({
    required this.id,
    required this.title,
    required this.countryId,
    required this.countryTitle,
  });
}

class Address {
  final int id;
  final bool isDefault;
  final AddressType addressType;
  final AddressCity city;
  final String addressLine1;
  final String? addressLine2;
  final String? latitude;
  final String? longitude;
  final String phone;

  Address({
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
}
