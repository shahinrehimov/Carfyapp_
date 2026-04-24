import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/advertisements/advertisement.dart';
import 'package:dartz/dartz.dart';

abstract class AdvertisementRepository {
  Future<Either<Failure, List<Advertisement>>> getActiveAdvertisements();
}
