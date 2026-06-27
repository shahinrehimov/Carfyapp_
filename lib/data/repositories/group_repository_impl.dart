import 'package:carfy/common/error/failure.dart';
import 'package:carfy/common/mixin/repository_safe_call_mixin.dart';
import 'package:carfy/data/datasources/group_remote_data_source.dart';
import 'package:carfy/data/dtos/group/group_query_params.dart';
import 'package:carfy/data/dtos/group/groups_bulk_query_params.dart';
import 'package:carfy/data/mappers/group_mapper.dart';
import 'package:carfy/domain/entities/group/group.dart';
import 'package:carfy/domain/params/group/group_params.dart';
import 'package:carfy/domain/params/group/groups_bulk_params.dart';
import 'package:carfy/domain/repositories/group_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: GroupRepository)
class GroupRepositoryImpl extends GroupRepository with RepositorySafeCallMixin {
  final GroupRemoteDataSource _remoteDataSource;
  final GroupMapper _mapper;

  GroupRepositoryImpl(this._remoteDataSource, this._mapper);

  @override
  Future<Either<Failure, List<Group>>> getGroupsList() {
    return safeCall(() async {
      final res = await _remoteDataSource.fetchGroupsList();
      return res.map(_mapper.mapGroup).toList();
    });
  }

  @override
  Future<Either<Failure, Group>> getGroup(GroupParams params) {
    return safeCall(() async {
      final queryParams = GroupQueryParams(slug: params.slug, limit: params.limit);
      final res = await _remoteDataSource.fetchGroup(queryParams);
      return _mapper.mapGroup(res);
    });
  }

  @override
  Future<Either<Failure, List<Group>>> getGroupsBulk(GroupsBulkParams params) {
    return safeCall(() async {
      final queryParams = GroupsBulkQueryParams(groups: params.groups);
      final res = await _remoteDataSource.fetchGroupsBulk(queryParams);
      return res.map(_mapper.mapGroup).toList();
    });
  }
}
