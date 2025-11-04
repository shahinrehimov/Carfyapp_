import 'package:dio/dio.dart';

import '../error/exceptions.dart';

mixin DataSourceMixin {
  Future<T> handleResponse<T>(Future<Response> Function() call, {T Function(dynamic data)? map}) async {
    try {
      final response = await call();

      if (response.statusCode == 200) {
        if (map != null) {
          try {
            return map(response.data);
          } catch (e) {
            throw ParseException();
          }
        }
        return response.data;
      }

      if (response.statusCode == 400) {
        final data = response.data;
        if (data is Map<String, dynamic> && data.containsKey('errors')) {
          final errors = Map<String, List<String>>.from(
            (data['errors'] as Map).map((key, value) => MapEntry(key.toString(), List<String>.from(value))),
          );
          throw ValidationException(errors);
        }
        throw ServerException();
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
      throw ServerException();
    }
  }
}
