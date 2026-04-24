part of 'product_list_cubit.dart';

class ProductListState extends Equatable {
  final StateStatus status;
  final List<Product> products;
  final int totalCount;
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

  const ProductListState({
    required this.status,
    required this.products,
    required this.totalCount,
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

  bool get hasFilters =>
      search != null ||
      brands != null ||
      categories != null ||
      subCategories != null ||
      cityId != null ||
      colors != null ||
      conditions != null ||
      minYear != null ||
      maxYear != null ||
      minPrice != null ||
      maxPrice != null;

  factory ProductListState.initial() => ProductListState(
    status: StateStatus.loading(),
    products: const [],
    totalCount: 0,
  );

  ProductListState copyWith({
    StateStatus? status,
    List<Product>? products,
    int? totalCount,
    String? search,
    String? sort,
    String? sortType,
    List<String>? brands,
    List<String>? categories,
    List<String>? subCategories,
    String? isSet,
    double? minPrice,
    double? maxPrice,
    int? cityId,
    String? sellerStoreCode,
    List<String>? colors,
    List<String>? conditions,
    int? minYear,
    int? maxYear,
  }) {
    return ProductListState(
      status: status ?? this.status,
      products: products ?? this.products,
      totalCount: totalCount ?? this.totalCount,
      search: search ?? this.search,
      sort: sort ?? this.sort,
      sortType: sortType ?? this.sortType,
      brands: brands ?? this.brands,
      categories: categories ?? this.categories,
      subCategories: subCategories ?? this.subCategories,
      isSet: isSet ?? this.isSet,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      cityId: cityId ?? this.cityId,
      sellerStoreCode: sellerStoreCode ?? this.sellerStoreCode,
      colors: colors ?? this.colors,
      conditions: conditions ?? this.conditions,
      minYear: minYear ?? this.minYear,
      maxYear: maxYear ?? this.maxYear,
    );
  }

  @override
  List<Object?> get props => [
    status, products, totalCount, search, sort, sortType,
    brands, categories, subCategories, isSet, minPrice, maxPrice,
    cityId, sellerStoreCode, colors, conditions, minYear, maxYear,
  ];
}
