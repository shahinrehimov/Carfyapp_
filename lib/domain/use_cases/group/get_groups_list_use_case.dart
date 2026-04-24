import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/group/group.dart';
import 'package:carfy/domain/repositories/group_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetGroupsListUseCase {
  final GroupRepository _repository;

  GetGroupsListUseCase(this._repository);

  Future<Either<Failure, List<Group>>> call() => _repository.getGroupsList();
}
