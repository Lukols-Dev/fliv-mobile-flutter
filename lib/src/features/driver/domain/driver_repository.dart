import 'register_driver_account_payload.dart';
import 'driver_profile.dart';
import 'update_driver_documents_payload.dart';
import 'update_user_profile_payload.dart';

abstract class DriverRepository {
  Future<void> registerDriverAccount({
    required RegisterDriverAccountPayload payload,
  });
  Future<DriverProfile> getProfile();
  Future<void> updateProfile(UpdateUserProfilePayload payload);
  Future<void> updateDocuments(UpdateDriverDocumentsPayload payload);
}
