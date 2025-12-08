import 'package:dartz/dartz.dart';

import '../../common/error/failure.dart';
import '../entities/translation/translations.dart';

abstract class TranslationRepository {
  Future<Either<Failure, Translations>> getRemoteTranslations(String languageCode);

  Future<Either<Failure, Translations?>> getCachedTranslations(String languageCode);

  Future<Either<Failure, Unit>> saveTranslationsToCache(String languageCode, Translations translations);
}
