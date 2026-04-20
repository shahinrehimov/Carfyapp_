import 'package:carfy/common/error/failure.dart';
import 'package:carfy/domain/params/contact/send_contact_params.dart';
import 'package:dartz/dartz.dart';

abstract class ContactRepository {
  Future<Either<Failure, void>> sendContact(SendContactParams params);
}
