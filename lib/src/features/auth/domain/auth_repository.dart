import 'auth_session.dart';

abstract class AuthRepository {
  Future<AuthSession> login({required String email, required String password});
  Future<AuthSession> signUpEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required bool isAgreedToTerms,
    required bool isAgreedToPrivacyPolicy,
  });
  Future<void> signOut();
}
