import 'package:dio/dio.dart';

import '../error/exceptions.dart';

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
          try {
            return map(response.data);
          } catch (e) {
            throw ParseException();
          }
        }
        return response.data;
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
