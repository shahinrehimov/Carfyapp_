import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../constants/constants.dart';

@singleton
class NetworkManager {
  late Dio dio;

  NetworkManager() {
    dio = Dio(
      BaseOptions(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        validateStatus: (_) => true,
        baseUrl: Constants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        headers: {"Accept": "application/json", "Content-Type": "application/json"},
      ),
    );
  }

  Future<Response> post(String url, {dynamic data, dynamic queryParameters}) async {
    return await dio.post(url, data: data, queryParameters: queryParameters);
  }

  Future<Response> put(String url, {dynamic data, dynamic queryParameters}) async {
    return await dio.put(url, data: data, queryParameters: queryParameters);
  }

  Future<Response> patch(String url, {dynamic data}) async {
    return await dio.patch(url, data: data);
  }

  Future<Response> delete(String url, {dynamic data, dynamic queryParameters}) async {
    return await dio.delete(url, data: data, queryParameters: queryParameters);
  }

  Future<Response> get(String url, {Map<String, dynamic>? queryParams}) async {
    return await dio.get(url, queryParameters: queryParams);
  }

  Future<dynamic> getFile(String url, {Map<String, dynamic>? queryParams}) async {
    return await dio.get(
      url,
      queryParameters: queryParams,
      options: Options(responseType: ResponseType.bytes),
    );
  }
}
