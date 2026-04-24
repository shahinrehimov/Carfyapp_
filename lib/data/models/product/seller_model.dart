import 'package:carfy/data/models/product/city_model.dart';

class SellerModel {
  final String uuid;
  final String? storeCode;
  final String? label;
  final CityModel? city;
  final List<String> images;

  SellerModel({
    required this.uuid,
    this.storeCode,
    this.label,
    this.city,
    this.images = const [],
  });

  factory SellerModel.fromJson(Map<String, dynamic> json) {
    return SellerModel(
      uuid: json['uuid'] as String,
      storeCode: json['store_code'] as String?,
      label: (json['label'] ?? json['seller_label']) as String?,
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
