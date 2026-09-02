import 'package:carfy/data/models/product/availability_model.dart';
import 'package:carfy/data/models/product/city_model.dart';
import 'package:carfy/data/models/product/working_hour_model.dart';

class SellerModel {
  final String uuid;
  final String? storeCode;
  final String? label;
  final CityModel? city;
  final List<String> images;
  final AvailabilityModel? availability;
  final List<WorkingHourModel> workingHours;

  SellerModel({
    required this.uuid,
    this.storeCode,
    this.label,
    this.city,
    this.images = const [],
    this.availability,
    this.workingHours = const [],
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
      availability: json['availability'] != null
          ? AvailabilityModel.fromJson(json['availability'] as Map<String, dynamic>)
          : null,
      workingHours: json['working_hours'] != null
          ? (json['working_hours'] as List<dynamic>)
              .map((e) => WorkingHourModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}
