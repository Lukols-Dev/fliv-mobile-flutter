import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../domain/users_repository.dart';
import 'users_api.dart';

final usersApiProvider = Provider<UsersApi>((ref) {
  return UsersApi(ref.read(dioProvider));
});

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  return UsersRepositoryImpl(ref.read(usersApiProvider));
});

class UsersRepositoryImpl implements UsersRepository {
  UsersRepositoryImpl(this._api);

  final UsersApi _api;

  @override
  Future<String> uploadAvatar({required String filePath}) {
    return _api.uploadAvatar(filePath: filePath);
  }
}
