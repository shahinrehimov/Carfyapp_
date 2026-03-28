class ProductListParams {
  final int page;
  final int limit;
  final String? search;
  final String? sort;
  final String? sortType;
  final List<String>? brands;
  final List<String>? categories;
  final List<String>? subCategories;
  final String? isSet;
  final double? minPrice;
  final double? maxPrice;
  final int? cityId;
  final String? sellerStoreCode;
  final List<String>? colors;
  final List<String>? conditions;
  final int? minYear;
  final int? maxYear;

  ProductListParams({
    required this.page,
    required this.limit,
    this.search,
    this.sort,
    this.sortType,
    this.brands,
    this.categories,
    this.subCategories,
    this.isSet,
    this.minPrice,
    this.maxPrice,
    this.cityId,
    this.sellerStoreCode,
    this.colors,
    this.conditions,
    this.minYear,
    this.maxYear,
  });
}
