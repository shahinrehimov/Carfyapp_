import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/translation_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveTranslationVersionUseCase {
  final TranslationRepository _repository;

  SaveTranslationVersionUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String code, int version) =>
      _repository.saveTranslationVersion(code, version);
}
