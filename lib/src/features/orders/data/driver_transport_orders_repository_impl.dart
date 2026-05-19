import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../domain/driver_transport_order.dart';
import '../domain/driver_transport_order_details.dart';
import '../domain/driver_transport_orders_repository.dart';
import 'driver_transport_orders_api.dart';

final driverTransportOrdersApiProvider = Provider<DriverTransportOrdersApi>((
  ref,
) {
  return DriverTransportOrdersApi(ref.read(dioProvider));
});

final driverTransportOrdersRepositoryProvider =
    Provider<DriverTransportOrdersRepository>((ref) {
      return DriverTransportOrdersRepositoryImpl(
        ref.read(driverTransportOrdersApiProvider),
      );
    });

class DriverTransportOrdersRepositoryImpl
    implements DriverTransportOrdersRepository {
  DriverTransportOrdersRepositoryImpl(this._api);

  final DriverTransportOrdersApi _api;

  @override
  Future<DriverTransportOrder?> getLatest({String? status}) async {
    final items = await _api.list(page: 1, limit: 1, status: status);
    if (items.isEmpty) return null;
    return items.first.toDomain();
  }

  @override
  Future<void> assignByZtNumber({required String ztNumber}) async {
    await _api.assign(ztNumber: ztNumber.trim());
  }

  @override
  Future<DriverTransportOrderDetails> getById({required String id}) async {
    final dto = await _api.getOne(id: id);
    return dto.toDomain();
  }

  @override
  Future<DriverTransportOrder> updateStatus({
    required String id,
    required String status,
    String? description,
  }) async {
    final responseDto = await _api.updateStatus(
      id: id,
      status: status,
      description: description,
    );
    return responseDto.toDomain();
  }

  @override
  Future<DriverTransportOrder> reportProblem({
    required String id,
    required String description,
  }) async {
    final responseDto = await _api.reportProblem(
      id: id,
      description: description,
    );
    return responseDto.toDomain();
  }

  @override
  Future<void> unassign({required String id}) async {
    await _api.unassign(id: id);
  }
}
