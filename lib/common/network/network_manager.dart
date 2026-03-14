import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_curl_logger/dio_curl_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'package:carfy/common/constants/constants.dart';
import 'package:carfy/common/constants/preference_keys.dart';
import 'package:carfy/common/util/pref_util.dart';

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
        headers: {"Accept": "application/json", "Content-Type": "application/json", "Token": Constants.securityToken},
      ),
    );
    dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final guestIdentifier = PrefUtil.getString(AppPreferenceKeys.guestIdentifier);
          if (guestIdentifier != null && guestIdentifier.isNotEmpty) {
            options.headers["identifier"] = guestIdentifier;
          }

          final authToken = PrefUtil.getString(AppPreferenceKeys.authToken);
          if (authToken != null && authToken.isNotEmpty) {
            options.headers["Authorization"] = 'Bearer $authToken';
          }
          return handler.next(options);
        },
      ),
      if (kDebugMode) CurlLoggingInterceptor(showResponseLog: true, showRequestLog: false),
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
