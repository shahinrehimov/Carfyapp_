import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/products/wishlist_action_response.dart';
import 'package:carfy/domain/repositories/wishlist_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddToWishlistUseCase {
  final WishlistRepository _repository;

  AddToWishlistUseCase(this._repository);

  Future<Either<Failure, WishlistActionResponse>> call(String cpvUuid) async {
    return await _repository.addToWishlist(cpvUuid);
  }
}
