import 'package:carfy/common/constants/endpoint_paths.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/mixin/datasource_mixin.dart';
import 'package:carfy/common/network/network_manager.dart';
import 'package:carfy/data/models/advertisements/advertisement_model.dart';
import 'package:injectable/injectable.dart';

abstract class AdvertisementRemoteDataSource {
  Future<List<AdvertisementModel>> fetchActiveAdvertisements();
}

@Injectable(as: AdvertisementRemoteDataSource)
class AdvertisementRemoteDataSourceImpl extends AdvertisementRemoteDataSource with DataSourceMixin {
  final NetworkManager _networkManager = getIt<NetworkManager>();

  @override
  Future<List<AdvertisementModel>> fetchActiveAdvertisements() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.activeAdvertisements),
      map: (json) => json['data'].map<AdvertisementModel>((item) => AdvertisementModel.fromJson(item)).toList(),
    );
  }
}
