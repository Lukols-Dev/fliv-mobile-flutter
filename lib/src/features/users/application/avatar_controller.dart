import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../driver/application/cached_driver_profile_provider.dart';
import '../../driver/application/driver_profile_provider.dart';
import '../data/users_repository_impl.dart';

final avatarControllerProvider =
    AsyncNotifierProvider<AvatarController, void>(AvatarController.new);

/// Upload-only action. The avatar URL is part of the driver profile
/// ([driverProfileProvider]) and is the single source of truth — this
/// controller performs the upload and triggers a profile refresh so the
/// freshly uploaded avatar is picked up. Its state only reflects upload
/// progress.
class AvatarController extends AsyncNotifier<void> {
  @override
  void build() {}

  Future<void> uploadAvatar({required String filePath}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(usersRepositoryProvider);
      await repo.uploadAvatar(filePath: filePath);

      ref.invalidate(driverProfileProvider);
      ref.invalidate(cachedDriverProfileProvider);
    });
  }
}
