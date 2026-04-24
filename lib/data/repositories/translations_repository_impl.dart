import 'package:carfy/common/error/failure.dart';
import 'package:carfy/data/datasources/translation_local_data_source.dart';
import 'package:carfy/data/datasources/translation_remote_data_source.dart';
import 'package:carfy/data/models/translation/translation_local_model.dart';
import 'package:carfy/domain/entities/translation/translations.dart';
import 'package:carfy/domain/repositories/translation_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:carfy/common/mixin/repository_safe_call_mixin.dart';

@Injectable(as: TranslationRepository)
class TranslationsRepositoryImpl extends TranslationRepository with RepositorySafeCallMixin {
  final TranslationRemoteDataSource _remoteDataSource;
  final TranslationLocalDataSource _localDataSource;

  TranslationsRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, Translations>> getRemoteTranslations(String languageCode) {
    return safeCall(() async {
      final res = await _remoteDataSource.getTranslations(languageCode);
      return Translations(translations: res.translations);
    });
  }

  @override
  Future<Either<Failure, Translations?>> getCachedTranslations(String languageCode) {
    return safeCall(() async {
      final res = await _localDataSource.getTranslations(languageCode);
      if (res == null) {
        return null;
      }
      return Translations(translations: res.translations);
    });
  }

  @override
  Future<Either<Failure, Unit>> saveTranslationsToCache(String languageCode, Translations translations) {
    return safeCall(() async {
      return await _localDataSource.saveTranslations(
        TranslationLocalModel(translations: translations.translations),
        languageCode,
      );
    });
  }
}
