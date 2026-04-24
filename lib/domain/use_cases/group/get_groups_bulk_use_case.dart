import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/group/group.dart';
import 'package:carfy/domain/params/group/groups_bulk_params.dart';
import 'package:carfy/domain/repositories/group_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetGroupsBulkUseCase {
  final GroupRepository _repository;

  GetGroupsBulkUseCase(this._repository);

  Future<Either<Failure, List<Group>>> call(GroupsBulkParams params) async {
    return await _repository.getGroupsBulk(params);
  }
}
