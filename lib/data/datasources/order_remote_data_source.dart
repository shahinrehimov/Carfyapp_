import 'package:carfy/common/constants/endpoint_paths.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/mixin/datasource_mixin.dart';
import 'package:carfy/common/network/network_manager.dart';
import 'package:carfy/data/models/orders/checkout_preview_model.dart';
import 'package:injectable/injectable.dart';

abstract class OrderRemoteDataSource {
  Future<CheckoutPreviewModel> getCheckoutPreview();
}

@Injectable(as: OrderRemoteDataSource)
class OrderRemoteDataSourceImpl extends OrderRemoteDataSource with DataSourceMixin {
  final NetworkManager _networkManager = getIt<NetworkManager>();

  @override
  Future<CheckoutPreviewModel> getCheckoutPreview() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.checkoutPreview),
      map: (json) => CheckoutPreviewModel.fromJson(json),
    );
  }
}
