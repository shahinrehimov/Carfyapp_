import 'package:carfy/common/constants/endpoint_paths.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/mixin/datasource_mixin.dart';
import 'package:carfy/common/network/network_manager.dart';
import 'package:carfy/data/models/payment/payment_method_model.dart';
import 'package:injectable/injectable.dart';

abstract class PaymentRemoteDataSource {
  Future<List<PaymentMethodModel>> getPaymentMethods();
}

@Injectable(as: PaymentRemoteDataSource)
class PaymentRemoteDataSourceImpl extends PaymentRemoteDataSource with DataSourceMixin {
  final NetworkManager _networkManager = getIt<NetworkManager>();

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.paymentMethods),
      map: (json) =>
          (json['data'] as List<dynamic>).map((e) => PaymentMethodModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
