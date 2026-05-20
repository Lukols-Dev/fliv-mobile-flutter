import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/features/orders/application/current_driver_order_provider.dart';

import '../../../core/network/connectivity_provider.dart';
import '../data/driver_orders_local_data_source.dart';
import '../data/driver_transport_orders_repository_impl.dart';

final updateOrderStatusControllerProvider =
    AsyncNotifierProvider<UpdateOrderStatusController, void>(
      UpdateOrderStatusController.new,
    );

class UpdateOrderStatusController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> updateStatus({
    required String orderId,
    required String status,
    String? description,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(driverTransportOrdersRepositoryProvider);
      final local = ref.read(driverOrdersLocalDataSourceProvider);

      final isOnline = await ref
          .read(networkStatusControllerProvider.notifier)
          .checkNow(force: true);
      if (!isOnline) {
        throw Exception('Nie można zmienić statusu w trybie offline');
      }

      // Update status via API
      final updatedOrder = await repo.updateStatus(
        id: orderId,
        status: status,
        description: description,
      );

      // Update local cache
      await local.upsertCurrent(updatedOrder);

      // Invalidate current order provider to refresh UI
      ref.invalidate(currentDriverOrderProvider);

      return;
    });
  }
}
