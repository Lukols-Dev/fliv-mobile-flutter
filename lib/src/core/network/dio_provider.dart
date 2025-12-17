import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/core/config/env.dart';
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
      headers: const {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.add(CookieManager(ref.read(cookieJarProvider)));

  return dio;
});
