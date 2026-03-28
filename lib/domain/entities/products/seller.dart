import 'package:carfy/domain/entities/products/city.dart';

class Seller {
  final String uuid;
  final String? storeCode;
  final String? label;
  final City? city;
  final List<String> images;

  Seller({
    required this.uuid,
    this.storeCode,
    this.label,
    this.city,
    this.images = const [],
  });
}
