import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/secure_storage_provider.dart';
import '../data/users_repository_impl.dart';

final avatarControllerProvider =
    AsyncNotifierProvider<AvatarController, String?>(AvatarController.new);

class AvatarController extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    final storage = ref.read(secureStorageProvider);
    final url = await storage.read(key: kAvatarUrlKey);
    return (url == null || url.trim().isEmpty) ? null : url;
  }

  Future<void> uploadAvatar({required String filePath}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(usersRepositoryProvider);
      final url = await repo.uploadAvatar(filePath: filePath);

      final storage = ref.read(secureStorageProvider);
      await storage.write(key: kAvatarUrlKey, value: url);

      return url;
    });
  }
}
