import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/auth_session.dart';
import '../data/auth_repository_impl.dart';
import '../../../core/storage/secure_storage_provider.dart';
import '../../driver/data/driver_repository_impl.dart';
import '../../driver/domain/register_driver_payload.dart';
import '../../driver/data/driver_local_data_source.dart';
import 'package:mobile/src/features/orders/data/driver_orders_local_data_source.dart';
import 'package:mobile/src/features/orders/data/driver_transport_orders_repository_impl.dart';

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthSession?>(AuthController.new);

class AuthController extends AsyncNotifier<AuthSession?> {
  @override
  Future<AuthSession?> build() async {
    final storage = ref.read(secureStorageProvider);
    final token = await storage.read(key: kAccessTokenKey);
    if (token == null || token.isEmpty) return null;
    return AuthSession(accessToken: token);
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final driverLocal = ref.read(driverLocalDataSourceProvider);
      final ordersLocal = ref.read(driverOrdersLocalDataSourceProvider);

      await driverLocal.clearMyProfile();
      await ordersLocal.clearAll();

      // Login
      final authRepo = ref.read(authRepositoryProvider);
      final session = await authRepo.login(email: email, password: password);

      // Token
      final storage = ref.read(secureStorageProvider);
      await storage.write(key: kAccessTokenKey, value: session.accessToken);

      // Prefetch
      final driverRepo = ref.read(driverRepositoryProvider);
      final ordersRepo = ref.read(driverTransportOrdersRepositoryProvider);

      try {
        final profile = await driverRepo.getProfile();
        await driverLocal.upsertMyProfile(profile);
      } catch (_) {}

      try {
        final current = await ordersRepo.getLatest();
        // If backend returns null (no order) then clear local
        if (current == null) {
          await ordersLocal.clearAll();
        } else {
          await ordersLocal.upsertCurrent(current);

          // // MVP: details tylko jeśli naprawdę potrzebujesz na Home / od razu.
          // // Jak nie – możesz to pominąć i pobierać dopiero na screenie szczegółów.
          try {
            final details = await ordersRepo.getById(id: current.id);
            await ordersLocal.upsertDetails(details);
          } catch (_) {}
        }
      } catch (_) {}

      return session;
    });
  }

  Future<void> signUpDriver({
    required String email,
    required String password,
    required RegisterDriverPayload driver,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final authRepo = ref.read(authRepositoryProvider);

      final session = await authRepo.signUpEmail(
        email: email,
        password: password,
      );

      final token = session.accessToken;

      final driverRepo = ref.read(driverRepositoryProvider);
      await driverRepo.registerDriver(payload: driver);

      final storage = ref.read(secureStorageProvider);
      await storage.write(key: kAccessTokenKey, value: token);

      return session;
    });
  }

  Future<void> signOut() async {
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.signOut();
    } catch (e) {
      print('Sign out API error: $e');
    } finally {
      final storage = ref.read(secureStorageProvider);
      await storage.delete(key: kAccessTokenKey);

      final driverLocal = ref.read(driverLocalDataSourceProvider);
      final ordersLocal = ref.read(driverOrdersLocalDataSourceProvider);

      await driverLocal.clearMyProfile();
      await ordersLocal.clearAll();

      state = const AsyncData(null);
    }
  }
}
