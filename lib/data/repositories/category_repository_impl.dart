import 'package:carfy/common/error/failure.dart';
import 'package:carfy/common/mixin/repository_safe_call_mixin.dart';
import 'package:carfy/data/datasources/category_remote_data_source.dart';
import 'package:carfy/data/mappers/category_mapper.dart';
import 'package:carfy/domain/entities/categories/category.dart';
import 'package:carfy/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CategoryRepository)
class CategoryRepositoryImpl extends CategoryRepository with RepositorySafeCallMixin {
  final CategoryRemoteDataSource _remoteDataSource;
  final CategoryMapper _mapper;

  CategoryRepositoryImpl(this._remoteDataSource, this._mapper);

  @override
  Future<Either<Failure, List<Category>>> getCategories() {
    return safeCall(() async {
      final res = await _remoteDataSource.fetchCategories();
      return res.map((e) => _mapper.mapCategory(e)).toList();
    });
  }
}
