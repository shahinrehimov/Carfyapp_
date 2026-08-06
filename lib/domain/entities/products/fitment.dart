import 'package:carfy/domain/entities/products/brand_model_item.dart';

class Fitment {
  final BrandModelItem? brand;
  final BrandModelItem? brandModel;
  final int? yearFrom;
  final int? yearTo;

  Fitment({this.brand, this.brandModel, this.yearFrom, this.yearTo});
}
