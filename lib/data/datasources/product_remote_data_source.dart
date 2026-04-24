import 'package:carfy/common/data/models/pagination_response_model.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/mixin/datasource_mixin.dart';
import 'package:carfy/common/network/network_manager.dart';
import 'package:carfy/data/dtos/product/load_reviews_query_params.dart';
import 'package:carfy/data/dtos/product/other_sellers_query_params.dart';
import 'package:carfy/data/dtos/product/product_list_query_params.dart';
import 'package:carfy/data/dtos/product/product_show_query_params.dart';
import 'package:carfy/data/dtos/product/store_review_dto.dart';
import 'package:carfy/data/models/product/other_seller_model.dart';
import 'package:carfy/data/models/product/product_filters_model.dart';
import 'package:carfy/data/models/product/product_model.dart';
import 'package:carfy/data/models/product/product_show_model.dart';
import 'package:carfy/data/models/product/review_model.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:carfy/common/constants/endpoint_paths.dart';

abstract class ProductRemoteDataSource {
  Future<PaginationResponseModel<ProductModel>> fetchProducts(ProductListQueryParams params);
  Future<ProductFiltersModel> fetchProductFilters();
  Future<ProductShowModel> fetchProductShow(String endpoint, ProductShowQueryParams params);
  Future<PaginationResponseModel<OtherSellerModel>> fetchOtherSellers(int variantId, OtherSellersQueryParams params);
  Future<ReviewModel> storeReview(String cpvUuid, StoreReviewDto dto);
  Future<PaginationResponseModel<ReviewModel>> loadReviews(String cpvUuid, LoadReviewsQueryParams params);
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

  @override
  Future<ProductFiltersModel> fetchProductFilters() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.productFilters),
      map: (json) => ProductFiltersModel.fromJson(json),
    );
  }

  @override
  Future<ProductShowModel> fetchProductShow(String endpoint, ProductShowQueryParams params) {
    return handleResponse(
      () => _networkManager.get(endpoint, queryParams: params.toQueryParameters()),
      map: (json) => ProductShowModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<PaginationResponseModel<OtherSellerModel>> fetchOtherSellers(int variantId, OtherSellersQueryParams params) {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.otherSellers(variantId), queryParams: params.toQueryParameters()),
      map: (json) => PaginationResponseModel.fromJson(json, (item) => OtherSellerModel.fromJson(item)),
    );
  }

  @override
  Future<ReviewModel> storeReview(String cpvUuid, StoreReviewDto dto) async {
    final formData = FormData();
    formData.fields.addAll([
      MapEntry('rating', dto.rating.toString()),
      MapEntry('name', dto.name),
      MapEntry('surname', dto.surname),
      MapEntry('email', dto.email),
      MapEntry('review', dto.review),
    ]);
    for (final path in dto.imagePaths) {
      formData.files.add(MapEntry('images[]', await MultipartFile.fromFile(path)));
    }
    return handleResponse(
      () => _networkManager.post(EndpointPaths.reviewStore(cpvUuid), data: formData),
      map: (json) => ReviewModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  @override
  Future<PaginationResponseModel<ReviewModel>> loadReviews(String cpvUuid, LoadReviewsQueryParams params) {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.reviewsLoad(cpvUuid), queryParams: params.toQueryParameters()),
      map: (json) => PaginationResponseModel.fromJson(json, (item) => ReviewModel.fromJson(item)),
    );
  }
}
