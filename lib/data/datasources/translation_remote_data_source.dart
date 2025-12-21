import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/mixin/datasource_mixin.dart';
import 'package:carfy/common/network/network_manager.dart';
import 'package:injectable/injectable.dart';

import 'package:carfy/common/constants/endpoint_paths.dart';
import 'package:carfy/data/models/translation/translations_model.dart';

abstract class TranslationRemoteDataSource {
  Future<TranslationModel> getTranslations(String languageCode);
}

@Injectable(as: TranslationRemoteDataSource)
class TranslationRemoteDataSourceImpl extends TranslationRemoteDataSource with DataSourceMixin {
  final NetworkManager _networkManager = getIt<NetworkManager>();

  @override
  Future<TranslationModel> getTranslations(String languageCode) {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.translations(languageCode)),
      map: (json) => TranslationModel.fromJson(json),
    );
  }
}
