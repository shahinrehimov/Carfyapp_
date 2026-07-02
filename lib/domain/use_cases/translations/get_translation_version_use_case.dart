import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/translation_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTranslationVersionUseCase {
  final TranslationRepository _repository;

  GetTranslationVersionUseCase(this._repository);

  Future<Either<Failure, int>> call(String code) => _repository.getSavedTranslationVersion(code);
}
