import 'package:carfy/common/domain/entities/pagination_response.dart';
import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/products/review.dart';
import 'package:carfy/domain/params/product/load_reviews_params.dart';
import 'package:carfy/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoadReviewsUseCase {
  final ProductRepository _repository;

  LoadReviewsUseCase(this._repository);

  Future<Either<Failure, PaginationResponse<Review>>> call(LoadReviewsParams params) async {
    return await _repository.loadReviews(params);
  }
}
