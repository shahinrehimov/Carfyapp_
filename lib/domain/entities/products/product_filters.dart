import 'package:carfy/domain/entities/products/city.dart';
import 'package:carfy/domain/entities/products/filter_brand.dart';
import 'package:carfy/domain/entities/products/filter_category.dart';
import 'package:carfy/domain/entities/products/filter_option.dart';
import 'package:carfy/domain/entities/products/price_range.dart';
import 'package:carfy/domain/entities/products/sort_option.dart';
import 'package:carfy/domain/entities/products/year_range.dart';

class ProductFilters {
  final List<FilterCategory> categories;
  final List<FilterBrand> brands;
  final List<City> cities;
  final PriceRange priceRange;
  final List<FilterOption> colors;
  final List<FilterOption> conditions;
  final YearRange? yearRange;
  final List<SortOption> sortOptions;
  final List<SortOption> sortTypes;

  ProductFilters({
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
}
