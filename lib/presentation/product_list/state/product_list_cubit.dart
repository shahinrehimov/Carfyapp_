import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/helper/pagination_helper.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/products/product.dart';
import 'package:carfy/domain/params/product/product_list_params.dart';
import 'package:carfy/domain/use_cases/product/get_products_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_list_state.dart';

class ProductListCubit extends Cubit<ProductListState> with StateMapHelper {
  final GetProductsUseCase _getProductsUseCase;
  final PaginationHelper _paginationHelper = PaginationHelper();

  ProductListCubit({GetProductsUseCase? getProductsUseCase})
      : _getProductsUseCase = getProductsUseCase ?? getIt<GetProductsUseCase>(),
        super(ProductListState.initial());

  Future<void> init({
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
  }) async {
    _paginationHelper.reset();
    emit(ProductListState(
      status: StateStatus.loading(),
      products: const [],
      totalCount: 0,
      search: search,
      sort: sort,
      sortType: sortType,
      brands: brands,
      categories: categories,
      subCategories: subCategories,
      isSet: isSet,
      minPrice: minPrice,
      maxPrice: maxPrice,
      cityId: cityId,
      sellerStoreCode: sellerStoreCode,
      colors: colors,
      conditions: conditions,
      minYear: minYear,
      maxYear: maxYear,
    ));
    _loadProducts();
  }

  void applySearch(String? search) {
    _paginationHelper.reset();
    emit(ProductListState(
      status: StateStatus.loading(),
      products: const [],
      totalCount: 0,
      search: search,
      sort: state.sort,
      sortType: state.sortType,
      brands: state.brands,
      categories: state.categories,
      subCategories: state.subCategories,
      isSet: state.isSet,
      minPrice: state.minPrice,
      maxPrice: state.maxPrice,
      cityId: state.cityId,
      sellerStoreCode: state.sellerStoreCode,
      colors: state.colors,
      conditions: state.conditions,
      minYear: state.minYear,
      maxYear: state.maxYear,
    ));
    _loadProducts();
  }

  void applyFilters({
    List<String>? brands,
    List<String>? categories,
    List<String>? subCategories,
    int? cityId,
    List<String>? colors,
    List<String>? conditions,
    int? minYear,
    int? maxYear,
    double? minPrice,
    double? maxPrice,
  }) {
    _paginationHelper.reset();
    emit(ProductListState(
      status: StateStatus.loading(),
      products: const [],
      totalCount: 0,
      search: state.search,
      sort: state.sort,
      sortType: state.sortType,
      brands: brands,
      categories: categories,
      subCategories: subCategories,
      isSet: state.isSet,
      minPrice: minPrice,
      maxPrice: maxPrice,
      cityId: cityId,
      sellerStoreCode: state.sellerStoreCode,
      colors: colors,
      conditions: conditions,
      minYear: minYear,
      maxYear: maxYear,
    ));
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    if (!_paginationHelper.shouldLoad()) return;

    emit(state.copyWith(status: _paginationHelper.getLoadingStatus()));
    _paginationHelper.onLoadStart();

    final result = await _getProductsUseCase(ProductListParams(
      page: _paginationHelper.currentPage,
      limit: 10,
      search: state.search,
      sort: state.sort,
      sortType: state.sortType,
      brands: state.brands,
      categories: state.categories,
      subCategories: state.subCategories,
      isSet: state.isSet,
      minPrice: state.minPrice,
      maxPrice: state.maxPrice,
      cityId: state.cityId,
      sellerStoreCode: state.sellerStoreCode,
      colors: state.colors,
      conditions: state.conditions,
      minYear: state.minYear,
      maxYear: state.maxYear,
    ));

    result.fold(
      (failure) => emit(state.copyWith(status: mapFailure(failure))),
      (response) {
        _paginationHelper.onLoadEnd(response.lastPage);
        final updatedProducts = [...state.products, ...response.data];
        emit(state.copyWith(
          status: StateStatus.success(),
          products: updatedProducts,
          totalCount: response.total,
        ));
      },
    );
  }

  Future<void> loadNextPage() async {
    await _loadProducts();
  }

  Future<void> refresh() async {
    _paginationHelper.reset();
    emit(state.copyWith(products: [], totalCount: 0));
    await _loadProducts();
  }

  void updateSort(String? sort, String? sortType) {
    _paginationHelper.reset();
    emit(state.copyWith(sort: sort, sortType: sortType, products: [], totalCount: 0));
    _loadProducts();
  }

  void resetFilters() {
    _paginationHelper.reset();
    emit(ProductListState(
      status: StateStatus.loading(),
      products: const [],
      totalCount: 0,
      search: state.search,
      sort: state.sort,
      sortType: state.sortType,
      isSet: state.isSet,
      sellerStoreCode: state.sellerStoreCode,
    ));
    _loadProducts();
  }

  void resetSort() {
    _paginationHelper.reset();
    emit(ProductListState(
      status: StateStatus.loading(),
      products: const [],
      totalCount: 0,
      search: state.search,
      brands: state.brands,
      categories: state.categories,
      subCategories: state.subCategories,
      isSet: state.isSet,
      minPrice: state.minPrice,
      maxPrice: state.maxPrice,
      cityId: state.cityId,
      sellerStoreCode: state.sellerStoreCode,
      colors: state.colors,
      conditions: state.conditions,
      minYear: state.minYear,
      maxYear: state.maxYear,
    ));
    _loadProducts();
  }
}
