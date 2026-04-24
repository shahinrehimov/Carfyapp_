import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/group/group.dart';
import 'package:carfy/domain/params/group/group_params.dart';
import 'package:carfy/domain/repositories/group_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetGroupUseCase {
  final GroupRepository _repository;

  GetGroupUseCase(this._repository);

  Future<Either<Failure, Group>> call(GroupParams params) async {
    return await _repository.getGroup(params);
  }
}
