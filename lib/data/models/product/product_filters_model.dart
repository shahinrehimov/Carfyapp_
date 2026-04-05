import 'package:carfy/data/models/product/city_model.dart';
import 'package:carfy/data/models/product/filter_brand_model.dart';
import 'package:carfy/data/models/product/filter_category_model.dart';
import 'package:carfy/data/models/product/filter_option_model.dart';
import 'package:carfy/data/models/product/price_range_model.dart';
import 'package:carfy/data/models/product/sort_option_model.dart';
import 'package:carfy/data/models/product/year_range_model.dart';

class ProductFiltersModel {
  final List<FilterCategoryModel> categories;
  final List<FilterBrandModel> brands;
  final List<CityModel> cities;
  final PriceRangeModel priceRange;
  final List<FilterOptionModel> colors;
  final List<FilterOptionModel> conditions;
  final YearRangeModel? yearRange;
  final List<SortOptionModel> sortOptions;
  final List<SortOptionModel> sortTypes;

  ProductFiltersModel({
    required this.categories,
    required this.brands,
    required this.cities,
    required this.priceRange,
    this.colors = const [],
    this.conditions = const [],
    this.yearRange,
    this.sortOptions = const [],
    this.sortTypes = const [],
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
      sortOptions: data['sort_options'] != null
          ? (data['sort_options'] as List).map((e) => SortOptionModel.fromJson(e)).toList()
          : [],
      sortTypes: data['sort_types'] != null
          ? (data['sort_types'] as List).map((e) => SortOptionModel.fromJson(e)).toList()
          : [],
    );
  }
}
