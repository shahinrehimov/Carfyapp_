import 'package:carfy/common/error/failure.dart';
import 'package:carfy/common/mixin/repository_safe_call_mixin.dart';
import 'package:carfy/data/datasources/basket_remote_data_source.dart';
import 'package:carfy/data/mappers/basket_mapper.dart';
import 'package:carfy/domain/entities/basket/basket_response.dart';
import 'package:carfy/domain/repositories/basket_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: BasketRepository)
class BasketRepositoryImpl extends BasketRepository with RepositorySafeCallMixin {
  final BasketRemoteDataSource _remoteDataSource;
  final BasketMapper _mapper;

  BasketRepositoryImpl(this._remoteDataSource, this._mapper);

  @override
  Future<Either<Failure, BasketResponse>> getBasket() {
    return safeCall(() async {
      final res = await _remoteDataSource.fetchBasket();
      return _mapper.mapBasketResponse(res);
    });
  }
}
