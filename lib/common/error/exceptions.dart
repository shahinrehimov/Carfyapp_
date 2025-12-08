import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  @override
  List<Object> get props => [];
}

class ValidationException implements Exception {
  final Map<String, List<String>> errors;

  ValidationException(this.errors);

  @override
  String toString() => 'ValidationException: $errors';
}

class ConnectionException extends Equatable implements Exception {
  @override
  List<Object?> get props => [];
}

class UnavailableException extends Equatable implements Exception {
  @override
  List<Object?> get props => [];
}

class ParseException extends Equatable implements Exception {
  @override
  List<Object> get props => [];
}

class UserException extends Equatable implements Exception {
  final String message;

  const UserException({required this.message});

  @override
  List<Object> get props => [];
}
