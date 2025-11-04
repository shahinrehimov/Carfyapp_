import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../error/exceptions.dart';
import '../error/failure.dart';

mixin RepositorySafeCallMixin {
  Future<Either<Failure, T>> safeCall<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return Right(result);
    } on ValidationException catch (e) {
      _logError(e);
      return Left(ValidationFailure(e.errors));
    } on ConnectionException catch (e) {
      _logError(e);
      return Left(ConnectionFailure());
    } on ParseException catch (e) {
      _logError(e);
      return Left(ServerFailure());
    } on ServerException catch (e) {
      _logError(e);
      return Left(ServerFailure());
    }
  }

  void _logError(Object error) {
    log('Exception: $error');
  }
}
