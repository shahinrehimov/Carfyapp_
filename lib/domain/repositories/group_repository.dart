import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/group/group.dart';
import 'package:carfy/domain/params/group/group_params.dart';
import 'package:dartz/dartz.dart';

abstract class GroupRepository {
  Future<Either<Failure, Group>> getGroup(GroupParams params);
}
