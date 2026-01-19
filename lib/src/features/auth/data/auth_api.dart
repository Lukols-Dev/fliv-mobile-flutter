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
      '/api/auth/sign-in/email',
      data: {'email': email, 'password': password},
    );

    return LoginResponseDto.fromJson(res.data as Map<String, dynamic>);
  }

  Future<SignUpResponseDto> signUpEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required bool isAgreedToTerms,
    required bool isAgreedToPrivacyPolicy,
  }) async {
    final res = await _dio.post(
      '/api/auth/sign-up/email',
      data: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'isAgreedToTerms': isAgreedToTerms,
        'isAgreedToPrivacyPolicy': isAgreedToPrivacyPolicy,
      },
    );
    return SignUpResponseDto.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> signOut() async {
    await _dio.post('/api/auth/sign-out');
  }
}
