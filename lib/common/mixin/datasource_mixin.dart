import 'package:dio/dio.dart';

import 'package:carfy/common/error/exceptions.dart';

mixin DataSourceMixin {
  Exception handleException(Exception e) {
    if (e is DioException) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        return ConnectionException();
      }
      return ServerException();
    } else {
      return e;
    }
  }

  Future<T> handleResponse<T>(Future<Response> Function() call, {T Function(dynamic data)? map}) async {
    try {
      final response = await call();

      if (response.statusCode == 200) {
        if (map != null) {
          return map(response.data);
        }
        return response.data;
      } else if (response.statusCode == 400) {
        throw UserException(message: response.data['message']);
      } else if (response.statusCode == 401) {
        throw UserException(message: response.data['message']);
      } else if (response.statusCode == 403) {
        throw UserException(message: response.data['message']);
      } else if (response.statusCode == 422) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('errors')) {
          final errors = Map<String, List<String>>.from(
            (data['errors'] as Map).map((key, value) => MapEntry(key.toString(), List<String>.from(value))),
          );
          throw ValidationException(errors);
        }
        throw ServerException();
      } else if (response.statusCode == 429) {
        throw UserException(message: response.data['message']);
      }

      throw ServerException();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw ConnectionException();
      }
      throw ServerException();
    } on Exception {
      rethrow;
    }
  }
}
