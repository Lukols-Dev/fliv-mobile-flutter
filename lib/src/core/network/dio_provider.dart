import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/core/config/env.dart';
import 'package:mobile/src/core/network/connectivity_provider.dart';
import 'cookie_jar_provider.dart';

final dioProvider = Provider<Dio>((ref) {
  Env.validate();

  final baseUrl = Env.apiBaseUrl.isNotEmpty
      ? Env.apiBaseUrl
      : 'http://10.0.2.2:4000';

  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: const {'Content-Type': 'application/json', 'x-client': 'mobile'},
    ),
  );

  dio.interceptors.add(CookieManager(ref.read(cookieJarProvider)));
  dio.interceptors.add(_NetworkStatusInterceptor(ref));

  return dio;
});

class _NetworkStatusInterceptor extends Interceptor {
  _NetworkStatusInterceptor(this._ref);

  final Ref _ref;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _ref.read(networkStatusControllerProvider.notifier).markOnline();
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_isNetworkError(err)) {
      _ref.read(networkStatusControllerProvider.notifier).markOffline();
    } else if (err.response != null) {
      _ref.read(networkStatusControllerProvider.notifier).markOnline();
    }
    handler.next(err);
  }

  bool _isNetworkError(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return true;
      case DioExceptionType.unknown:
        return err.error is SocketException;
      case DioExceptionType.badCertificate:
      case DioExceptionType.badResponse:
      case DioExceptionType.cancel:
        return false;
    }
  }
}
