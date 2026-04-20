import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/advertisements/advertisement.dart';
import 'package:carfy/domain/repositories/advertisement_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetActiveAdvertisementsUseCase {
  final AdvertisementRepository _repository;

  GetActiveAdvertisementsUseCase(this._repository);

  Future<Either<Failure, List<Advertisement>>> call() async {
    return await _repository.getActiveAdvertisements();
  }
}
