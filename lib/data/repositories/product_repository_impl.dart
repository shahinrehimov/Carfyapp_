import 'package:carfy/common/constants/endpoint_paths.dart';
import 'package:carfy/common/domain/entities/pagination_response.dart';
import 'package:carfy/common/error/failure.dart';
import 'package:carfy/common/mixin/repository_safe_call_mixin.dart';
import 'package:carfy/data/datasources/product_remote_data_source.dart';
import 'package:carfy/data/dtos/product/load_reviews_query_params.dart';
import 'package:carfy/data/dtos/product/other_sellers_query_params.dart';
import 'package:carfy/data/dtos/product/product_list_query_params.dart';
import 'package:carfy/data/dtos/product/product_show_query_params.dart';
import 'package:carfy/data/dtos/product/store_review_dto.dart';
import 'package:carfy/data/mappers/product_mapper.dart';
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
        search: params.search,
        sort: params.sort,
        sortType: params.sortType,
        brands: params.brands,
        categories: params.categories,
        subCategories: params.subCategories,
        isSet: params.isSet,
        minPrice: params.minPrice,
        maxPrice: params.maxPrice,
        cityId: params.cityId,
        sellerStoreCode: params.sellerStoreCode,
        colors: params.colors,
        conditions: params.conditions,
        minYear: params.minYear,
        maxYear: params.maxYear,
      );
      final res = await _remoteDataSource.fetchProducts(queryParams);
      return _mapper.mapPaginationResponse(res);
    });
  }

  @override
  Future<Either<Failure, ProductFilters>> getProductFilters() {
    return safeCall(() async {
      final res = await _remoteDataSource.fetchProductFilters();
      return _mapper.mapProductFilters(res);
    });
  }

  @override
  Future<Either<Failure, ProductShow>> getProductShow(ProductShowParams params) {
    return safeCall(() async {
      final endpoint = EndpointPaths.productShow(params.cpvUuid);
      final queryParams = ProductShowQueryParams(otherSellers: params.otherSellers, withRelated: params.withRelated);
      final res = await _remoteDataSource.fetchProductShow(endpoint, queryParams);
      return _mapper.mapProductShow(res);
    });
  }

  @override
  Future<Either<Failure, PaginationResponse<OtherSeller>>> getOtherSellers(OtherSellersParams params) {
    return safeCall(() async {
      final queryParams = OtherSellersQueryParams(page: params.page, limit: params.limit);
      final res = await _remoteDataSource.fetchOtherSellers(params.productVariantId, queryParams);
      return _mapper.mapOtherSellersPaginationResponse(res);
    });
  }

  @override
  Future<Either<Failure, Review>> storeReview(StoreReviewParams params) {
    return safeCall(() async {
      final dto = StoreReviewDto(
        rating: params.rating,
        name: params.name,
        surname: params.surname,
        email: params.email,
        review: params.review,
        imagePaths: params.imagePaths,
      );
      final res = await _remoteDataSource.storeReview(params.cpvUuid, dto);
      return _mapper.mapReview(res);
    });
  }

  @override
  Future<Either<Failure, PaginationResponse<Review>>> loadReviews(LoadReviewsParams params) {
    return safeCall(() async {
      final queryParams = LoadReviewsQueryParams(page: params.page, limit: params.limit);
      final res = await _remoteDataSource.loadReviews(params.cpvUuid, queryParams);
      return _mapper.mapReviewsPaginationResponse(res);
    });
  }
}
