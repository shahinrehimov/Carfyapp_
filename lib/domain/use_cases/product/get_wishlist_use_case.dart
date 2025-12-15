import 'package:carfy/common/domain/entities/pagination_response.dart';
import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/products/product.dart';
import 'package:carfy/domain/params/product/product_list_params.dart';
import 'package:carfy/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetWishlistUseCase {
  final ProductRepository _repository;

  GetWishlistUseCase(this._repository);

  Future<Either<Failure, PaginationResponse<Product>>> call(ProductListParams params) async {
    return await _repository.getWishlist(params);
  }
}
