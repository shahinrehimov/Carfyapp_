import 'package:carfy/common/constants/endpoint_paths.dart';
import 'package:carfy/common/data/models/pagination_response_model.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/mixin/datasource_mixin.dart';
import 'package:carfy/common/network/network_manager.dart';
import 'package:carfy/data/dtos/product/product_list_query_params.dart';
import 'package:carfy/data/models/product/product_model.dart';
import 'package:carfy/data/models/product/wishlist_action_response_model.dart';
import 'package:injectable/injectable.dart';

abstract class WishlistRemoteDataSource {
  Future<PaginationResponseModel<ProductModel>> fetchWishlist(ProductListQueryParams params);
  Future<List<String>> fetchWishlistIds();
  Future<WishlistActionResponseModel> addToWishlist(String cpvUuid);
  Future<WishlistActionResponseModel> removeFromWishlist(String cpvUuid);
}

@Injectable(as: WishlistRemoteDataSource)
class WishlistRemoteDataSourceImpl extends WishlistRemoteDataSource with DataSourceMixin {
  final NetworkManager _networkManager = getIt<NetworkManager>();

  @override
  Future<PaginationResponseModel<ProductModel>> fetchWishlist(ProductListQueryParams params) {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.wishlist, queryParams: params.toQueryParameters()),
      map: (json) => PaginationResponseModel.fromJson(json, (item) => ProductModel.fromJson(item)),
    );
  }

  @override
  Future<List<String>> fetchWishlistIds() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.wishlistIds),
      map: (json) => (json['data'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  @override
  Future<WishlistActionResponseModel> addToWishlist(String cpvUuid) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.wishlistAdd(cpvUuid)),
      map: (json) => WishlistActionResponseModel.fromJson(json),
    );
  }

  @override
  Future<WishlistActionResponseModel> removeFromWishlist(String cpvUuid) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.wishlistRemove(cpvUuid)),
      map: (json) => WishlistActionResponseModel.fromJson(json),
    );
  }
}
