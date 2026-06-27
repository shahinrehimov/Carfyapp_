import 'package:carfy/data/models/product/city_model.dart';

class OtherSellerModel {
  final String uuid;
  final String sellerLabel;
  final double price;
  final double priceFinal;
  final bool hasDiscount;
  final String? discountType;
  final double discount;
  final int stock;
  final CityModel? city;
  final List<String> images;

  OtherSellerModel({
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

  factory OtherSellerModel.fromJson(Map<String, dynamic> json) {
    return OtherSellerModel(
      uuid: json['uuid'] as String,
      sellerLabel: json['seller_label'] as String,
      price: (json['price'] as num).toDouble(),
      priceFinal: (json['price_final'] as num).toDouble(),
      hasDiscount: json['has_discount'] as bool,
      discountType: json['discount_type'] as String?,
      discount: (json['discount'] as num).toDouble(),
      stock: json['stock'] as int,
      city: json['city'] != null ? CityModel.fromJson(json['city'] as Map<String, dynamic>) : null,
      images: json['images'] != null
          ? (json['images'] as List<dynamic>).map((e) {
              if (e is String) return e;
              if (e is Map<String, dynamic>) return (e['url'] ?? '') as String;
              return '';
            }).toList()
          : [],
    );
  }
}
