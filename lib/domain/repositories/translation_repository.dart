import 'package:dartz/dartz.dart';

import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/translation/app_language.dart';
import 'package:carfy/domain/entities/translation/translations.dart';

abstract class TranslationRepository {
  Future<Either<Failure, Translations>> getRemoteTranslations(String languageCode);

  Future<Either<Failure, Translations?>> getCachedTranslations(String languageCode);

  Future<Either<Failure, Unit>> saveTranslationsToCache(String languageCode, Translations translations);

  Future<Either<Failure, List<AppLanguage>>> getLanguagesList();
}
