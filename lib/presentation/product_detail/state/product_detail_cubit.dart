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

  ProductDetailCubit({
    GetProductShowUseCase? getProductShowUseCase,
    LoadReviewsUseCase? loadReviewsUseCase,
  })  : _getProductShowUseCase = getProductShowUseCase ?? getIt<GetProductShowUseCase>(),
        _loadReviewsUseCase = loadReviewsUseCase ?? getIt<LoadReviewsUseCase>(),
        super(ProductDetailState.initial());

  Future<void> init(ProductShowParams params) async {
    emit(state.copyWith(status: StateStatus.loading()));

    final result = await _getProductShowUseCase(params);
    result.fold(
      (failure) => emit(state.copyWith(status: mapFailure(failure))),
      (productShow) {
        emit(state.copyWith(
          status: StateStatus.success(),
          product: productShow,
          selectedImageIndex: 0,
        ));
        if (productShow.ratings != null && productShow.ratings!.count > 0) {
          _loadReviews(productShow.seller?.uuid ?? productShow.uuid);
        }
      },
    );
  }

  Future<void> _loadReviews(String cpvUuid) async {
    emit(state.copyWith(reviewsStatus: StateStatus.loading()));
    final result = await _loadReviewsUseCase(LoadReviewsParams(
      cpvUuid: cpvUuid,
      page: 1,
      limit: 3,
    ));
    result.fold(
      (failure) => emit(state.copyWith(reviewsStatus: mapFailure(failure))),
      (response) => emit(state.copyWith(
        reviewsStatus: StateStatus.success(),
        reviews: response.data,
        totalReviews: response.total,
      )),
    );
  }

  void selectImage(int index) {
    emit(state.copyWith(selectedImageIndex: index));
  }
}
