import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/domain/auth_repository.dart';
import '../../auth/domain/auth_session.dart';
import '../../../core/network/dio_provider.dart';
import 'auth_api.dart';

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.read(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(authApiProvider));
});

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._api);
  final AuthApi _api;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final dto = await _api.login(email: email, password: password);
    return AuthSession(accessToken: dto.accessToken);
  }

  @override
  Future<AuthSession> signUpEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required bool isAgreedToTerms,
    required bool isAgreedToPrivacyPolicy,
  }) async {
    final dto = await _api.signUpEmail(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      isAgreedToTerms: isAgreedToTerms,
      isAgreedToPrivacyPolicy: isAgreedToPrivacyPolicy,
    );
    return AuthSession(accessToken: dto.accessToken);
  }

  @override
  Future<void> signOut() async {
    await _api.signOut();
  }
}
