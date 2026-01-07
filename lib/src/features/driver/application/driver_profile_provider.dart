import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/connectivity_provider.dart';
import '../../auth/application/auth_controller.dart';
import '../data/driver_local_data_source.dart';
import '../data/driver_repository_impl.dart';
import '../domain/driver_profile.dart';

final driverProfileProvider = FutureProvider<DriverProfile>((ref) async {
  // Tie cached provider state to auth session so switching accounts can't reuse
  // previous user's in-memory value.
  final session = await ref.watch(authControllerProvider.future);
  if (session == null) {
    throw Exception('Not authenticated');
  }

  final repo = ref.read(driverRepositoryProvider);
  final local = ref.read(driverLocalDataSourceProvider);

  // If we know we're offline, return cached profile (if any).
  if (ref.watch(isOfflineProvider)) {
    final cached = await local.getMyProfile();
    if (cached != null) return cached;
    throw Exception('Offline and no cached driver profile');
  }

  try {
    final profile = await repo.getProfile().timeout(const Duration(seconds: 6));
    await local.upsertMyProfile(profile);
    return profile;
  } catch (_) {
    final cached = await local.getMyProfile();
    if (cached != null) return cached;
    rethrow;
  }
});
