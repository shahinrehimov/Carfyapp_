import 'package:carfy/common/constants/endpoint_paths.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/mixin/datasource_mixin.dart';
import 'package:carfy/common/network/network_manager.dart';
import 'package:carfy/data/models/setting/app_setting_model.dart';
import 'package:injectable/injectable.dart';

abstract class SettingRemoteDataSource {
  Future<AppSettingModel> getAppSetting();
}

@Injectable(as: SettingRemoteDataSource)
class SettingRemoteDataSourceImpl extends SettingRemoteDataSource with DataSourceMixin {
  final NetworkManager _networkManager = getIt<NetworkManager>();

  @override
  Future<AppSettingModel> getAppSetting() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.appSetting),
      map: (json) => AppSettingModel.fromJson(json),
    );
  }
}
