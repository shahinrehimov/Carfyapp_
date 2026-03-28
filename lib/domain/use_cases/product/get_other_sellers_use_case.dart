import 'package:carfy/common/domain/entities/pagination_response.dart';
import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/products/other_seller.dart';
import 'package:carfy/domain/params/product/other_sellers_params.dart';
import 'package:carfy/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetOtherSellersUseCase {
  final ProductRepository _repository;

  GetOtherSellersUseCase(this._repository);

  Future<Either<Failure, PaginationResponse<OtherSeller>>> call(OtherSellersParams params) async {
    return await _repository.getOtherSellers(params);
  }
}
