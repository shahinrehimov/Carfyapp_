import 'package:carfy/common/error/failure.dart';
import 'package:carfy/common/mixin/repository_safe_call_mixin.dart';
import 'package:carfy/data/datasources/advertisement_remote_data_source.dart';
import 'package:carfy/data/mappers/advertisement_mapper.dart';
import 'package:carfy/domain/entities/advertisements/advertisement.dart';
import 'package:carfy/domain/repositories/advertisement_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AdvertisementRepository)
class AdvertisementRepositoryImpl extends AdvertisementRepository with RepositorySafeCallMixin {
  final AdvertisementRemoteDataSource _remoteDataSource;
  final AdvertisementMapper _mapper;

  AdvertisementRepositoryImpl(this._remoteDataSource, this._mapper);

  @override
  Future<Either<Failure, List<Advertisement>>> getActiveAdvertisements() {
    return safeCall(() async {
      final res = await _remoteDataSource.fetchActiveAdvertisements();
      return res.map((e) => _mapper.mapAdvertisement(e)).toList();
    });
  }
}
