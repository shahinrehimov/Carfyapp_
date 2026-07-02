import 'package:carfy/common/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract class SearchHistoryRepository {
  Future<Either<Failure, List<String>>> getHistory();
  Future<Either<Failure, Unit>> add(String query);
  Future<Either<Failure, Unit>> remove(String query);
  Future<Either<Failure, Unit>> clear();
}
