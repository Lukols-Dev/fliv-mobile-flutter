import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/application/auth_controller.dart';
import '../data/driver_local_data_source.dart';
import '../domain/driver_profile.dart';

/// Szybki odczyt tylko z Drift (bez network).
final cachedDriverProfileProvider = FutureProvider<DriverProfile?>((ref) async {
  // Ensure cached value is not reused between accounts.
  ref.watch(authControllerProvider);
  final local = ref.read(driverLocalDataSourceProvider);
  return local.getMyProfile();
});
