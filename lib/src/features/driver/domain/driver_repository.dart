import 'register_driver_payload.dart';
import 'driver_profile.dart';
import 'update_driver_documents_payload.dart';
import 'update_user_profile_payload.dart';

abstract class DriverRepository {
  Future<void> registerDriver({required RegisterDriverPayload payload});
  Future<DriverProfile> getProfile();
  Future<void> updateProfile(UpdateUserProfilePayload payload);
  Future<void> updateDocuments(UpdateDriverDocumentsPayload payload);
}
