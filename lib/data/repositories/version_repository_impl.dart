import 'package:carfy/common/error/failure.dart';
import 'package:carfy/common/mixin/repository_safe_call_mixin.dart';
import 'package:carfy/domain/entities/versions/version.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:carfy/domain/repositories/version_repository.dart';
import 'package:carfy/data/datasources/version_remote_data_source.dart';

@Injectable(as: VersionRepository)
class VersionRepositoryImpl extends VersionRepository with RepositorySafeCallMixin {
  final VersionRemoteDataSource _remoteDataSource;

  VersionRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Version>> getVersions() async {
    return safeCall(() async {
      final res = await _remoteDataSource.getCurrentVersion();
      return Version(langVersion: res.langVersion, defaultLang: res.defaultLang);
    });
  }
}
