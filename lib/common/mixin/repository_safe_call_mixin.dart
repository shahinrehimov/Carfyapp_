import 'dart:developer';

import 'package:dartz/dartz.dart';

import 'package:carfy/common/error/exceptions.dart';
import 'package:carfy/common/error/failure.dart';

mixin RepositorySafeCallMixin {
  Future<Either<Failure, T>> safeCall<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return Right(result);
    } on ValidationException catch (e) {
      _logError(e);
      return Left(ValidationFailure(e.errors));
    } on RateLimitException catch (e) {
      _logError(e);
      return Left(RateLimitFailure(retryAfter: e.retryAfter));
    } on UserException catch (e) {
      _logError(e);
      return Left(UserFailure(message: e.message));
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
