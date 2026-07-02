import 'package:carfy/common/error/failure.dart';
import 'package:carfy/common/mixin/repository_safe_call_mixin.dart';
import 'package:carfy/data/datasources/search_history_local_data_source.dart';
import 'package:carfy/domain/repositories/search_history_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SearchHistoryRepository)
class SearchHistoryRepositoryImpl extends SearchHistoryRepository with RepositorySafeCallMixin {
  final SearchHistoryLocalDataSource _localDataSource;

  SearchHistoryRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<String>>> getHistory() {
    return safeCall(() => _localDataSource.getHistory());
  }

  @override
  Future<Either<Failure, Unit>> add(String query) {
    return safeCall(() async {
      await _localDataSource.add(query);
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> remove(String query) {
    return safeCall(() async {
      await _localDataSource.remove(query);
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> clear() {
    return safeCall(() async {
      await _localDataSource.clear();
      return unit;
    });
  }
}
