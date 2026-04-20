import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/params/contact/send_contact_params.dart';
import 'package:carfy/domain/repositories/contact_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class SendContactUseCase {
  final ContactRepository _repository;

  SendContactUseCase(this._repository);

  Future<Either<Failure, void>> call(SendContactParams params) async {
    return await _repository.sendContact(params);
  }
}
