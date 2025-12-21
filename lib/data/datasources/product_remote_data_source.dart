import 'package:carfy/common/data/models/pagination_response_model.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/mixin/datasource_mixin.dart';
import 'package:carfy/common/network/network_manager.dart';
import 'package:carfy/data/dtos/product/product_list_query_params.dart';
import 'package:carfy/data/models/product/product_model.dart';
import 'package:injectable/injectable.dart';

import 'package:carfy/common/constants/endpoint_paths.dart';

abstract class ProductRemoteDataSource {
  Future<PaginationResponseModel<ProductModel>> fetchProducts(ProductListQueryParams params);
}

@Injectable(as: ProductRemoteDataSource)
class ProductRemoteDataSourceImpl extends ProductRemoteDataSource with DataSourceMixin {
  final NetworkManager _networkManager = getIt<NetworkManager>();

  @override
  Future<PaginationResponseModel<ProductModel>> fetchProducts(ProductListQueryParams params) {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.products, queryParams: params.toQueryParameters()),
      map: (json) => PaginationResponseModel.fromJson(json, (item) => ProductModel.fromJson(item)),
    );
  }
}
