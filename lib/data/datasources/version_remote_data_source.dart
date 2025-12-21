import 'dart:convert';

import 'package:carfy/common/mixin/datasource_mixin.dart';
import 'package:carfy/data/models/version/version_model.dart';
import 'package:injectable/injectable.dart';

import 'package:carfy/common/constants/endpoint_paths.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/network/network_manager.dart';

abstract class VersionRemoteDataSource {
  Future<VersionModel> getCurrentVersion();
}

@Injectable(as: VersionRemoteDataSource)
class VersionRemoteDataSourceImpl extends VersionRemoteDataSource with DataSourceMixin {
  final NetworkManager _networkManager = getIt<NetworkManager>();

  @override
  Future<VersionModel> getCurrentVersion() async {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.versions),
      map: (json) => VersionModel.fromJson(jsonDecode(json)),
    );
  }
}
