import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../domain/driver_repository.dart';
import '../domain/driver_profile.dart';
import '../domain/register_driver_payload.dart';
import '../domain/update_driver_documents_payload.dart';
import '../domain/update_user_profile_payload.dart';

import 'driver_api.dart';

final driverApiProvider = Provider<DriverApi>((ref) {
  return DriverApi(ref.read(dioProvider));
});

final driverRepositoryProvider = Provider<DriverRepository>((ref) {
  return DriverRepositoryImpl(ref.read(driverApiProvider));
});

class DriverRepositoryImpl implements DriverRepository {
  DriverRepositoryImpl(this._api);
  final DriverApi _api;

  @override
  Future<void> registerDriver({required RegisterDriverPayload payload}) {
    return _api.registerDriver(payload: payload);
  }

  @override
  Future<DriverProfile> getProfile() async {
    final dto = await _api.getProfile();
    return dto.toDomain();
  }

  @override
  Future<void> updateProfile(UpdateUserProfilePayload payload) {
    return _api.updateProfile(payload);
  }

  @override
  Future<void> updateDocuments(UpdateDriverDocumentsPayload payload) {
    return _api.updateDocuments(payload);
  }
}
