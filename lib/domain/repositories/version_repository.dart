import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/versions/version.dart';
import 'package:dartz/dartz.dart';

abstract class VersionRepository {
  Future<Either<Failure, Version>> getVersions();
}
