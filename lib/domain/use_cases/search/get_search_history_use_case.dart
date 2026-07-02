import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/search_history_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSearchHistoryUseCase {
  final SearchHistoryRepository _repository;

  GetSearchHistoryUseCase(this._repository);

  Future<Either<Failure, List<String>>> call() => _repository.getHistory();
}
