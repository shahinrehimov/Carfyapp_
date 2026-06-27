class ProductListQueryParams {
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

  ProductListQueryParams({
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

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{'page': page, 'limit': limit};
    if (search != null) params['search'] = search;
    if (sort != null) params['sort'] = sort;
    if (sortType != null) params['sort_type'] = sortType;
    if (brands != null) params['brands[]'] = brands;
    if (categories != null) params['categories[]'] = categories;
    if (subCategories != null) params['sub_categories[]'] = subCategories;
    if (isSet != null) params['is_set'] = isSet;
    if (minPrice != null) params['min_price'] = minPrice;
    if (maxPrice != null) params['max_price'] = maxPrice;
    if (cityId != null) params['city_id'] = cityId;
    if (sellerStoreCode != null) params['seller_store_code'] = sellerStoreCode;
    if (colors != null) params['colors[]'] = colors;
    if (conditions != null) params['conditions[]'] = conditions;
    if (minYear != null) params['min_year'] = minYear;
    if (maxYear != null) params['max_year'] = maxYear;
    return params;
  }
}
