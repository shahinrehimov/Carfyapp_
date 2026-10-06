import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/products/search_suggestions.dart';
import 'package:carfy/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSearchSuggestionsUseCase {
  final ProductRepository _repository;

  GetSearchSuggestionsUseCase(this._repository);

  Future<Either<Failure, SearchSuggestions>> call(String search) =>
      _repository.getSuggestions(search);
}
