import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/mixin/datasource_mixin.dart';
import 'package:carfy/common/network/network_manager.dart';
import 'package:carfy/data/models/category/category_model.dart';
import 'package:injectable/injectable.dart';

import 'package:carfy/common/constants/endpoint_paths.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> fetchCategories();
}

@Injectable(as: CategoryRemoteDataSource)
class CategoryRemoteDataSourceImpl extends CategoryRemoteDataSource with DataSourceMixin {
  final NetworkManager _networkManager = getIt<NetworkManager>();

  @override
  Future<List<CategoryModel>> fetchCategories() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.categories),
      map: (json) => json['data'].map<CategoryModel>((item) => CategoryModel.fromJson(item)).toList(),
    );
  }
}
