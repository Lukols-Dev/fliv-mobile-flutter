import 'package:dio/dio.dart';

import 'auth_dto.dart';

class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  Future<LoginResponseDto> login({
    required String email,
    required String password,
  }) async {
    final res = await _dio.post(
      '/api/auth/sign-in/email', //TODO:
      data: {'email': email, 'password': password},
    );

    return LoginResponseDto.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> signOut() async {
    await _dio.post('/api/auth/sign-out');
  }
}
