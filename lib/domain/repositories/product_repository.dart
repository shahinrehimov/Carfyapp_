import 'package:carfy/common/domain/entities/pagination_response.dart';
import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/products/other_seller.dart';
import 'package:carfy/domain/entities/products/product.dart';
import 'package:carfy/domain/entities/products/product_filters.dart';
import 'package:carfy/domain/entities/products/product_show.dart';
import 'package:carfy/domain/entities/products/review.dart';
import 'package:carfy/domain/params/product/load_reviews_params.dart';
import 'package:carfy/domain/params/product/other_sellers_params.dart';
import 'package:carfy/domain/params/product/product_list_params.dart';
import 'package:carfy/domain/params/product/product_show_params.dart';
import 'package:carfy/domain/params/product/store_review_params.dart';
import 'package:dartz/dartz.dart';

abstract class ProductRepository {
  Future<Either<Failure, PaginationResponse<Product>>> getProducts(ProductListParams params);
  Future<Either<Failure, ProductFilters>> getProductFilters();
  Future<Either<Failure, ProductShow>> getProductShow(ProductShowParams params);
  Future<Either<Failure, PaginationResponse<OtherSeller>>> getOtherSellers(OtherSellersParams params);
  Future<Either<Failure, Review>> storeReview(StoreReviewParams params);
  Future<Either<Failure, PaginationResponse<Review>>> loadReviews(LoadReviewsParams params);
}
