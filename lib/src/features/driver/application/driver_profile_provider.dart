import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/driver_repository_impl.dart';
import '../domain/driver_profile.dart';

final driverProfileProvider = FutureProvider.autoDispose<DriverProfile>((
  ref,
) async {
  final repo = ref.read(driverRepositoryProvider);
  return repo.getProfile();
});
