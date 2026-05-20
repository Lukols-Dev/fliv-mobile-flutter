import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../driver/data/driver_repository_impl.dart';
import '../../driver/domain/register_driver_account_payload.dart';

final driverRegistrationControllerProvider =
    AsyncNotifierProvider<DriverRegistrationController, void>(
      DriverRegistrationController.new,
    );

/// Drives the driver self-registration screen. Kept separate from
/// [AuthController] on purpose: a successful registration must NOT establish
/// a session — the account still requires manual activation before sign-in.
class DriverRegistrationController extends AsyncNotifier<void> {
  @override
  void build() {}

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String companyInternalId,
    String? phone,
    required bool isAgreedToTerms,
    required bool isAgreedToPrivacyPolicy,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final driverRepo = ref.read(driverRepositoryProvider);
      await driverRepo.registerDriverAccount(
        payload: RegisterDriverAccountPayload(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
          companyInternalId: companyInternalId,
          phone: phone,
          isAgreedToTerms: isAgreedToTerms,
          isAgreedToPrivacyPolicy: isAgreedToPrivacyPolicy,
        ),
      );
    });
  }
}
