import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/entities/auth/sessions_response.dart';
import 'package:carfy/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSessionsUseCase {
  final AuthRepository _repository;
  GetSessionsUseCase(this._repository);

  Future<Either<Failure, SessionsResponse>> call() => _repository.getSessions();
}
