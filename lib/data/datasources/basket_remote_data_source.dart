import 'package:carfy/common/constants/endpoint_paths.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/mixin/datasource_mixin.dart';
import 'package:carfy/common/network/network_manager.dart';
import 'package:carfy/data/models/basket/basket_response_model.dart';
import 'package:injectable/injectable.dart';

abstract class BasketRemoteDataSource {
  Future<BasketResponseModel> fetchBasket();
}

@Injectable(as: BasketRemoteDataSource)
class BasketRemoteDataSourceImpl extends BasketRemoteDataSource with DataSourceMixin {
  final NetworkManager _networkManager = getIt<NetworkManager>();

  @override
  Future<BasketResponseModel> fetchBasket() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.basketLoad),
      map: (json) => BasketResponseModel.fromJson(json),
    );
  }
}
