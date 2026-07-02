import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/search_history_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class ClearSearchHistoryUseCase {
  final SearchHistoryRepository _repository;

  ClearSearchHistoryUseCase(this._repository);

  Future<Either<Failure, Unit>> call() => _repository.clear();
}
