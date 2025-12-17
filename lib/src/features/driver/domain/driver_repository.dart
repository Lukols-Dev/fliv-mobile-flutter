import 'register_driver_payload.dart';
import 'driver_profile.dart';

abstract class DriverRepository {
  Future<void> registerDriver({required RegisterDriverPayload payload});
  Future<DriverProfile> getProfile();
}
