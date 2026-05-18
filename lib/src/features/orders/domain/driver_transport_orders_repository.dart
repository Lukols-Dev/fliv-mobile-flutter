import 'driver_transport_order.dart';
import 'driver_transport_order_details.dart';

abstract class DriverTransportOrdersRepository {
  Future<DriverTransportOrder?> getLatest({String? status});
  Future<void> assignByZtNumber({required String ztNumber});
  Future<DriverTransportOrderDetails> getById({required String id});
  Future<DriverTransportOrder> updateStatus({
    required String id,
    required String status,
    String? description,
  });

  Future<DriverTransportOrder> reportProblem({
    required String id,
    required String description,
  });
}
