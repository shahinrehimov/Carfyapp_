import 'package:carfy/common/constants/endpoint_paths.dart';
import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/mixin/datasource_mixin.dart';
import 'package:carfy/common/network/network_manager.dart';
import 'package:carfy/data/dtos/group/group_query_params.dart';
import 'package:carfy/data/dtos/group/groups_bulk_query_params.dart';
import 'package:carfy/data/models/group/group_model.dart';
import 'package:injectable/injectable.dart';

abstract class GroupRemoteDataSource {
  Future<List<GroupModel>> fetchGroupsList();
  Future<GroupModel> fetchGroup(GroupQueryParams params);
  Future<List<GroupModel>> fetchGroupsBulk(GroupsBulkQueryParams params);
}

@Injectable(as: GroupRemoteDataSource)
class GroupRemoteDataSourceImpl extends GroupRemoteDataSource with DataSourceMixin {
  final NetworkManager _networkManager = getIt<NetworkManager>();

  @override
  Future<List<GroupModel>> fetchGroupsList() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.groupsList),
      map: (json) => (json['data'] as List<dynamic>)
          .map((item) => GroupModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<GroupModel> fetchGroup(GroupQueryParams params) {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.groupProducts(params.slug), queryParams: params.toQueryParameters()),
      map: (json) => GroupModel.fromJson(json['data']),
    );
  }

  @override
  Future<List<GroupModel>> fetchGroupsBulk(GroupsBulkQueryParams params) {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.groupsBulkProducts, queryParams: params.toQueryParameters()),
      map: (json) => (json['data'] as List<dynamic>)
          .map((item) => GroupModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
