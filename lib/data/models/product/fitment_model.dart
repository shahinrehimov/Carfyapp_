import 'package:carfy/data/models/product/brand_model_item_model.dart';

class FitmentModel {
  final BrandModelItemModel? brand;
  final BrandModelItemModel? brandModel;
  final int? yearFrom;
  final int? yearTo;

  FitmentModel({this.brand, this.brandModel, this.yearFrom, this.yearTo});

  factory FitmentModel.fromJson(Map<String, dynamic> json) {
    return FitmentModel(
      brand: json['brand'] != null ? BrandModelItemModel.fromJson(json['brand'] as Map<String, dynamic>) : null,
      brandModel:
          json['brand_model'] != null ? BrandModelItemModel.fromJson(json['brand_model'] as Map<String, dynamic>) : null,
      yearFrom: json['year_from'] as int?,
      yearTo: json['year_to'] as int?,
    );
  }
}
