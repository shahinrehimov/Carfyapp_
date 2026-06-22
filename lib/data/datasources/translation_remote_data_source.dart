import 'package:carfy/common/di/di.dart';
import 'package:carfy/common/mixin/datasource_mixin.dart';
import 'package:carfy/common/network/network_manager.dart';
import 'package:injectable/injectable.dart';

import 'package:carfy/common/constants/endpoint_paths.dart';
import 'package:carfy/data/models/translation/app_language_model.dart';
import 'package:carfy/data/models/translation/translations_model.dart';

abstract class TranslationRemoteDataSource {
  Future<TranslationModel> getTranslations(String languageCode);
  Future<List<AppLanguageModel>> getLanguagesList();
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

  @override
  Future<List<AppLanguageModel>> getLanguagesList() {
    return handleResponse(
      () => _networkManager.get(EndpointPaths.languagesList),
      map: (json) => (json['data'] as List<dynamic>)
          .map((item) => AppLanguageModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
