import 'package:carfy/common/domain/entities/pagination_response.dart';
import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/products/product.dart';
import 'package:carfy/domain/params/product/product_list_params.dart';
import 'package:dartz/dartz.dart';

abstract class ProductRepository {
  Future<Either<Failure, PaginationResponse<Product>>> getProducts(ProductListParams params);

  Future<Either<Failure, PaginationResponse<Product>>> getWishlist(ProductListParams params);
}
