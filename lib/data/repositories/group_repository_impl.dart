import 'package:carfy/common/error/failure.dart';
import 'package:carfy/common/mixin/repository_safe_call_mixin.dart';
import 'package:carfy/data/datasources/group_remote_data_source.dart';
import 'package:carfy/data/dtos/group/group_query_params.dart';
import 'package:carfy/data/mappers/group_mapper.dart';
import 'package:carfy/domain/entities/group/group.dart';
import 'package:carfy/domain/params/group/group_params.dart';
import 'package:carfy/domain/repositories/group_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GroupRepository)
class GroupRepositoryImpl extends GroupRepository with RepositorySafeCallMixin {
  final GroupRemoteDataSource _remoteDataSource;
  final GroupMapper _mapper;

  GroupRepositoryImpl(this._remoteDataSource, this._mapper);

  @override
  Future<Either<Failure, Group>> getGroup(GroupParams params) {
    return safeCall(() async {
      final queryParams = GroupQueryParams(
        slug: params.slug,
        limit: params.limit,
      );
      final res = await _remoteDataSource.fetchGroup(queryParams);
      return _mapper.mapGroup(res);
    });
  }
}
