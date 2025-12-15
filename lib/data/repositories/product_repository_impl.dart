import 'package:carfy/common/domain/entities/pagination_response.dart';
import 'package:carfy/common/error/failure.dart';
import 'package:carfy/common/mixin/repository_safe_call_mixin.dart';
import 'package:carfy/data/datasources/product_remote_data_source.dart';
import 'package:carfy/data/dtos/product/product_list_query_params.dart';
import 'package:carfy/data/mappers/product_mapper.dart';
import 'package:carfy/domain/entities/products/product.dart';
import 'package:carfy/domain/params/product/product_list_params.dart';
import 'package:carfy/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProductRepository)
class ProductRepositoryImpl extends ProductRepository with RepositorySafeCallMixin {
  final ProductRemoteDataSource _remoteDataSource;
  final ProductMapper _mapper;

  ProductRepositoryImpl(this._remoteDataSource, this._mapper);

  @override
  Future<Either<Failure, PaginationResponse<Product>>> getProducts(ProductListParams params) {
    return safeCall(() async {
      final queryParams = ProductListQueryParams(
        page: params.page,
        limit: params.limit,
      );
      final res = await _remoteDataSource.fetchProducts(queryParams);
      return _mapper.mapPaginationResponse(res);
    });
  }
}
