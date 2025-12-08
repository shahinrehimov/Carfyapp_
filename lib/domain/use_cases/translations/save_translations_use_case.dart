import 'package:carfy/domain/entities/translation/translations.dart';
import 'package:carfy/domain/repositories/translation_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import '../../../common/error/failure.dart';

@injectable
class SaveTranslationsUseCase {
  final TranslationRepository _repository;

  SaveTranslationsUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String languageCode, Translations translations) async {
    return await _repository.saveTranslationsToCache(languageCode, translations);
  }
}
