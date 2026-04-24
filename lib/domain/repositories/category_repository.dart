import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/categories/category.dart';
import 'package:dartz/dartz.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getCategories();
}
