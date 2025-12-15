import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/categories/category.dart';
import 'package:carfy/domain/entities/group/group.dart';
import 'package:carfy/domain/entities/products/product.dart';
import 'package:carfy/domain/params/group/group_params.dart';
import 'package:carfy/domain/params/product/product_list_params.dart';
import 'package:carfy/domain/use_cases/category/get_categories_use_case.dart';
import 'package:carfy/domain/use_cases/group/get_group_use_case.dart';
import 'package:carfy/domain/use_cases/product/get_products_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/helper/pagination_helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> with StateMapHelper {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetProductsUseCase _getProductsUseCase;
  final GetGroupUseCase _getGroupUseCase;
  final PaginationHelper _paymentPaginationHelper = PaginationHelper();

  HomeCubit({
    GetCategoriesUseCase? getCategoriesUseCase,
    GetProductsUseCase? getProductsUseCase,
    GetGroupUseCase? getGroupUseCase,
  }) : _getCategoriesUseCase = getCategoriesUseCase ?? getIt<GetCategoriesUseCase>(),
       _getProductsUseCase = getProductsUseCase ?? getIt<GetProductsUseCase>(),
       _getGroupUseCase = getGroupUseCase ?? getIt<GetGroupUseCase>(),
       super(HomeState.initial());

  Future<void> init() async {
    _loadCategories();
    _loadBestSeller();
    _loadProducts();
  }

  Future<void> _loadCategories() async {
    emit(state.copyWith(categoriesStatus: StateStatus.loading()));
    final result = await _getCategoriesUseCase();
    result.fold(
      (failure) {
        emit(state.copyWith(categoriesStatus: mapFailure(failure)));
      },
      (categories) {
        emit(state.copyWith(categoriesStatus: StateStatus.success(), categories: categories));
      },
    );
  }

  Future<void> _loadBestSeller() async {
    emit(state.copyWith(bestSellerStatus: StateStatus.loading()));
    final result = await _getGroupUseCase(GroupParams(slug: 'encoxsatilan', limit: 10));
    result.fold(
      (failure) {
        emit(state.copyWith(bestSellerStatus: mapFailure(failure)));
      },
      (group) {
        emit(state.copyWith(bestSellerStatus: StateStatus.success(), bestSeller: group));
      },
    );
  }

  Future<void> _loadProducts() async {
    if (!_paymentPaginationHelper.shouldLoad()) return;

    emit(state.copyWith(productsStatus: _paymentPaginationHelper.getLoadingStatus()));
    _paymentPaginationHelper.onLoadStart();

    final result = await _getProductsUseCase(ProductListParams(page: _paymentPaginationHelper.currentPage, limit: 8));
    result.fold(
      (failure) {
        emit(state.copyWith(productsStatus: mapFailure(failure)));
      },
      (response) {
        _paymentPaginationHelper.onLoadEnd(response.lastPage);
        final updatedProducts = [...state.products, ...response.data];
        emit(state.copyWith(productsStatus: StateStatus.success(), products: updatedProducts));
      },
    );
  }

  Future<void> loadNextProducts() async {
    await _loadProducts();
  }
}
