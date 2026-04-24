import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/products/review.dart';
import 'package:carfy/domain/params/product/store_review_params.dart';
import 'package:carfy/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class StoreReviewUseCase {
  final ProductRepository _repository;

  StoreReviewUseCase(this._repository);

  Future<Either<Failure, Review>> call(StoreReviewParams params) async {
    return await _repository.storeReview(params);
  }
}
