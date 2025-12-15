import 'package:carfy/common/constants/endpoint_paths.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/mixin/datasource_mixin.dart';
import 'package:carfy/common/network/network_manager.dart';
import 'package:carfy/data/dtos/group/group_query_params.dart';
import 'package:carfy/data/models/group/group_model.dart';
import 'package:injectable/injectable.dart';

abstract class GroupRemoteDataSource {
  Future<GroupModel> fetchGroup(GroupQueryParams params);
}

@Injectable(as: GroupRemoteDataSource)
class GroupRemoteDataSourceImpl extends GroupRemoteDataSource with DataSourceMixin {
  final NetworkManager _networkManager = getIt<NetworkManager>();

  @override
  Future<GroupModel> fetchGroup(GroupQueryParams params) {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.groupProducts(params.slug), queryParams: params.toQueryParameters()),
      map: (json) => GroupModel.fromJson(json['data']),
    );
  }
}
