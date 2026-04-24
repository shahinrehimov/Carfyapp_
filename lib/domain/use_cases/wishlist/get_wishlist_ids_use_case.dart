import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/repositories/wishlist_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetWishlistIdsUseCase {
  final WishlistRepository _repository;

  GetWishlistIdsUseCase(this._repository);

  Future<Either<Failure, List<String>>> call() => _repository.getWishlistIds();
}
