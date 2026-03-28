import 'package:carfy/common/domain/entities/pagination_response.dart';
import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/products/product.dart';
import 'package:carfy/domain/entities/products/wishlist_action_response.dart';
import 'package:carfy/domain/params/product/product_list_params.dart';
import 'package:dartz/dartz.dart';

abstract class WishlistRepository {
  Future<Either<Failure, PaginationResponse<Product>>> getWishlist(ProductListParams params);
  Future<Either<Failure, List<String>>> getWishlistIds();
  Future<Either<Failure, WishlistActionResponse>> addToWishlist(String cpvUuid);
  Future<Either<Failure, WishlistActionResponse>> removeFromWishlist(String cpvUuid);
}
