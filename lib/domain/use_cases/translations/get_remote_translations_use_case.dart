import 'package:carfy/domain/entities/translation/translations.dart';
import 'package:carfy/domain/repositories/translation_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import '../../../common/error/failure.dart';

@injectable
class GetRemoteTranslationsUseCase {
  final TranslationRepository _repository;

  GetRemoteTranslationsUseCase(this._repository);

  Future<Either<Failure, Translations>> call(String languageCode) async {
    return await _repository.getRemoteTranslations(languageCode);
  }
}
