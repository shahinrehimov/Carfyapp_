import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/translation_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSelectedLanguageUseCase {
  final TranslationRepository _repository;

  GetSelectedLanguageUseCase(this._repository);

  Future<Either<Failure, String?>> call() => _repository.getSelectedLanguage();
}
