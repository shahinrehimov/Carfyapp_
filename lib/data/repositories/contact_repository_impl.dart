import 'package:carfy/common/error/failure.dart';
import 'package:carfy/common/mixin/repository_safe_call_mixin.dart';
import 'package:carfy/data/datasources/contact_remote_data_source.dart';
import 'package:carfy/data/dtos/contact/send_contact_dto.dart';
import 'package:carfy/domain/params/contact/send_contact_params.dart';
import 'package:carfy/domain/repositories/contact_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ContactRepository)
class ContactRepositoryImpl extends ContactRepository with RepositorySafeCallMixin {
  final ContactRemoteDataSource _remoteDataSource;

  ContactRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, void>> sendContact(SendContactParams params) {
    return safeCall(() async {
      await _remoteDataSource.sendContact(
        SendContactDto(fullName: params.fullName, email: params.email, message: params.message),
      );
    });
  }
}
