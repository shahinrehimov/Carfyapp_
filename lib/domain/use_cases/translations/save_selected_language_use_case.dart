import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/translation_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveSelectedLanguageUseCase {
  final TranslationRepository _repository;

  SaveSelectedLanguageUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String code) => _repository.saveSelectedLanguage(code);
}
