import 'package:carfy/domain/entities/products/city.dart';

class OtherSeller {
  final String uuid;
  final String sellerLabel;
  final double price;
  final double priceFinal;
  final bool hasDiscount;
  final String? discountType;
  final double discount;
  final int stock;
  final City? city;
  final List<String> images;

  OtherSeller({
    required this.uuid,
    required this.sellerLabel,
    required this.price,
    required this.priceFinal,
    required this.hasDiscount,
    this.discountType,
    required this.discount,
    required this.stock,
    this.city,
    this.images = const [],
  });
}
