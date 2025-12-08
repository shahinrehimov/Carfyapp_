import 'package:carfy/domain/entities/versions/version.dart';
import 'package:carfy/domain/repositories/version_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import '../../../common/error/failure.dart';

@injectable
class GetVersionsUseCase {
  final VersionRepository _repository;

  GetVersionsUseCase(this._repository);

  Future<Either<Failure, Version>> call() async {
    return await _repository.getVersions();
  }
}
