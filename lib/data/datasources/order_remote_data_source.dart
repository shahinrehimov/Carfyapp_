import 'package:carfy/common/constants/endpoint_paths.dart';
import 'package:carfy/common/data/models/pagination_response_model.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/mixin/datasource_mixin.dart';
import 'package:carfy/common/network/network_manager.dart';
import 'package:carfy/data/dtos/orders/checkout_request_dto.dart';
import 'package:carfy/data/dtos/orders/orders_load_query_params.dart';
import 'package:carfy/data/models/orders/checkout_preview_model.dart';
import 'package:carfy/data/models/orders/checkout_result_model.dart';
import 'package:carfy/data/models/orders/order_summary_model.dart';
import 'package:injectable/injectable.dart';

abstract class OrderRemoteDataSource {
  Future<CheckoutPreviewModel> getCheckoutPreview(int addressId);
  Future<CheckoutResultModel> checkout(CheckoutRequestDto dto);
  Future<PaginationResponseModel<OrderSummaryModel>> loadOrders(OrdersLoadQueryParams params);
}

@Injectable(as: OrderRemoteDataSource)
class OrderRemoteDataSourceImpl extends OrderRemoteDataSource with DataSourceMixin {
  final NetworkManager _networkManager = getIt<NetworkManager>();

  @override
  Future<CheckoutPreviewModel> getCheckoutPreview(int addressId) {
    return handleResponse(
      () => _networkManager.get(
        EndpointPaths.checkoutPreview,
        queryParams: {'address_id': addressId},
      ),
      map: (json) => CheckoutPreviewModel.fromJson(json),
    );
  }

  @override
  Future<CheckoutResultModel> checkout(CheckoutRequestDto dto) {
    return handleResponse(
      () => _networkManager.post(EndpointPaths.checkout, data: dto.toJson()),
      map: (json) => CheckoutResultModel.fromJson(json),
    );
  }

  @override
  Future<PaginationResponseModel<OrderSummaryModel>> loadOrders(OrdersLoadQueryParams params) {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.ordersLoad, queryParams: params.toQueryParameters()),
      map: (json) => PaginationResponseModel.fromJson(json, (item) => OrderSummaryModel.fromJson(item)),
    );
  }
}
