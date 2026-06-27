import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/state/state_map_helper.dart';
import 'package:carfy/common/state/state_status.dart';
import 'package:carfy/domain/entities/products/product_show.dart';
import 'package:carfy/domain/entities/products/review.dart';
import 'package:carfy/domain/params/product/load_reviews_params.dart';
import 'package:carfy/domain/params/product/product_show_params.dart';
import 'package:carfy/domain/use_cases/product/get_product_show_use_case.dart';
import 'package:carfy/domain/use_cases/product/load_reviews_use_case.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> with StateMapHelper {
  final GetProductShowUseCase _getProductShowUseCase;
  final LoadReviewsUseCase _loadReviewsUseCase;

  static const int _reviewsPageSize = 5;
  int _reviewsPage = 1;

  ProductDetailCubit({GetProductShowUseCase? getProductShowUseCase, LoadReviewsUseCase? loadReviewsUseCase})
    : _getProductShowUseCase = getProductShowUseCase ?? getIt<GetProductShowUseCase>(),
      _loadReviewsUseCase = loadReviewsUseCase ?? getIt<LoadReviewsUseCase>(),
      super(ProductDetailState.initial());

  Future<void> init(ProductShowParams params) async {
    emit(state.copyWith(status: StateStatus.loading()));

    final result = await _getProductShowUseCase(params);
    result.fold((failure) => emit(state.copyWith(status: mapFailure(failure))), (productShow) {
      emit(state.copyWith(status: StateStatus.success(), product: productShow, selectedImageIndex: 0));
      if (productShow.ratings != null && productShow.ratings!.count > 0) {
        _loadReviews(productShow.seller?.uuid ?? productShow.uuid);
      }
    });
  }

  Future<void> reloadReviews() async {
    final product = state.product;
    if (product == null) return;
    await _loadReviews(product.seller?.uuid ?? product.uuid);
  }

  Future<void> loadMoreReviews() async {
    final product = state.product;
    if (product == null) return;
    if (state.reviews.length >= state.totalReviews) return;
    if (state.reviewsStatus is StateStatusLoading || state.reviewsStatus is StateStatusPaginationLoading) {
      return;
    }
    await _loadReviews(product.seller?.uuid ?? product.uuid, append: true);
  }

  Future<void> _loadReviews(String cpvUuid, {bool append = false}) async {
    if (append) {
      _reviewsPage += 1;
      emit(state.copyWith(reviewsStatus: StateStatus.paginationLoading()));
    } else {
      _reviewsPage = 1;
      emit(state.copyWith(reviewsStatus: StateStatus.loading()));
    }

    final result = await _loadReviewsUseCase(
      LoadReviewsParams(cpvUuid: cpvUuid, page: _reviewsPage, limit: _reviewsPageSize),
    );
    result.fold(
      (failure) {
        if (append) _reviewsPage -= 1;
        emit(state.copyWith(reviewsStatus: mapFailure(failure)));
      },
      (response) => emit(
        state.copyWith(
          reviewsStatus: StateStatus.success(),
          reviews: append ? [...state.reviews, ...response.data] : response.data,
          totalReviews: response.total,
        ),
      ),
    );
  }

  void selectImage(int index) {
    emit(state.copyWith(selectedImageIndex: index));
  }
}
