import 'package:carfy/domain/entities/categories/category.dart';
import 'package:carfy/domain/repositories/category_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';

import 'package:carfy/common/error/failure.dart';

@injectable
class GetCategoriesUseCase {
  final CategoryRepository _repository;

  GetCategoriesUseCase(this._repository);

  Future<Either<Failure, List<Category>>> call() async {
    return await _repository.getCategories();
  }
}
