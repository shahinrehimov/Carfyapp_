import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/translation/app_language.dart';
import 'package:carfy/domain/repositories/translation_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetLanguagesListUseCase {
  final TranslationRepository _repository;

  GetLanguagesListUseCase(this._repository);

  Future<Either<Failure, List<AppLanguage>>> call() => _repository.getLanguagesList();
}
