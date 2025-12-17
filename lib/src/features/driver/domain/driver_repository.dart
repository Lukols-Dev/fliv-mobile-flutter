import 'register_driver_payload.dart';

abstract class DriverRepository {
  Future<void> registerDriver({required RegisterDriverPayload payload});
}
