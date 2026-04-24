class ProductListPageParams {
  final bool fromFilter;
  final String? search;
  final List<String>? categories;
  final List<String>? subCategories;
  final List<String>? brands;
  final int? cityId;
  final List<String>? colors;
  final List<String>? conditions;
  final int? minYear;
  final int? maxYear;
  final double? minPrice;
  final double? maxPrice;

  const ProductListPageParams({
    this.fromFilter = false,
    this.search,
    this.categories,
    this.subCategories,
    this.brands,
    this.cityId,
    this.colors,
    this.conditions,
    this.minYear,
    this.maxYear,
    this.minPrice,
    this.maxPrice,
  });
}
