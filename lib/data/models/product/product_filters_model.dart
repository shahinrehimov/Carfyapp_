import 'package:carfy/data/models/product/city_model.dart';
import 'package:carfy/data/models/product/filter_brand_model.dart';
import 'package:carfy/data/models/product/filter_category_model.dart';
import 'package:carfy/data/models/product/filter_option_model.dart';
import 'package:carfy/data/models/product/price_range_model.dart';
import 'package:carfy/data/models/product/year_range_model.dart';

class ProductFiltersModel {
  final List<FilterCategoryModel> categories;
  final List<FilterBrandModel> brands;
  final List<CityModel> cities;
  final PriceRangeModel priceRange;
  final List<FilterOptionModel> colors;
  final List<FilterOptionModel> conditions;
  final YearRangeModel? yearRange;

  ProductFiltersModel({
    required this.categories,
    required this.brands,
    required this.cities,
    required this.priceRange,
    this.colors = const [],
    this.conditions = const [],
    this.yearRange,
  });

  factory ProductFiltersModel.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map<String, dynamic>?) ?? json;
    return ProductFiltersModel(
      categories: (data['categories'] as List)
          .map((e) => FilterCategoryModel.fromJson(e))
          .toList(),
      brands: (data['brands'] as List)
          .map((e) => FilterBrandModel.fromJson(e))
          .toList(),
      cities: (data['cities'] as List)
          .map((e) => CityModel.fromJson(e))
          .toList(),
      priceRange: PriceRangeModel.fromJson(data['price_ranges']),
      colors: data['colors'] != null
          ? (data['colors'] as List).map((e) => FilterOptionModel.fromJson(e)).toList()
          : [],
      conditions: data['conditions'] != null
          ? (data['conditions'] as List).map((e) => FilterOptionModel.fromJson(e)).toList()
          : [],
      yearRange: data['year_range'] != null
          ? YearRangeModel.fromJson(data['year_range'])
          : null,
    );
  }
}
