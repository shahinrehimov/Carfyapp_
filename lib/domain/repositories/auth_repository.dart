import 'package:dartz/dartz.dart';

import '../../common/error/failure.dart';
import '../entities/auth/auth_session.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthSession>> login({required String username, required String password});
}
