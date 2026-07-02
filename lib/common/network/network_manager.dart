import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_curl_logger/dio_curl_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'package:carfy/common/constants/constants.dart';
import 'package:carfy/data/datasources/auth_local_data_source.dart';
import 'package:carfy/data/datasources/locale_local_data_source.dart';

@singleton
class NetworkManager {
  late Dio dio;
  final AuthLocalDataSource _authLocal;
  final LocaleLocalDataSource _localeLocal;

  NetworkManager(this._authLocal, this._localeLocal) {
    dio = Dio(
      BaseOptions(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        validateStatus: (_) => true,
        baseUrl: Constants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        headers: {"Accept": "application/json", "Content-Type": "application/json", "Token": Constants.securityToken},
      ),
    );
    dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final guestIdentifier = await _authLocal.getGuestIdentifier();
          if (guestIdentifier != null && guestIdentifier.isNotEmpty) {
            options.headers["identifier"] = guestIdentifier;
          }

          final authToken = await _authLocal.getAuthToken();
          if (authToken != null && authToken.isNotEmpty) {
            options.headers["Authorization"] = 'Bearer $authToken';
          }

          final language = await _localeLocal.getSelectedLanguage() ??
              PlatformDispatcher.instance.locale.languageCode;
          options.headers["Accept-Language"] = language;

          return handler.next(options);
        },
      ),
      if (kDebugMode) CurlLoggingInterceptor(showResponseLog: true, showRequestLog: true),
    ]);
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
