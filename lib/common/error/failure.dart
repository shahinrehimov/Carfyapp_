import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class ServerFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class ConnectionFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class UserFailure extends Failure {
  final String _message;

  UserFailure({required String message}) : _message = message;

  String get message => _message;

  @override
  List<Object?> get props => [];
}

class UnavailableFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class ValidationFailure extends Failure {
  final Map<String, List<String>> errors;

  ValidationFailure(this.errors);

  @override
  List<Object?> get props => [errors];
}
