import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/driver_orders_local_data_source.dart';
import '../data/driver_transport_orders_repository_impl.dart';
import 'current_driver_order_provider.dart';

final unassignOrderControllerProvider =
    AsyncNotifierProvider<UnassignOrderController, void>(
      UnassignOrderController.new,
    );

class UnassignOrderController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> unassign({required String orderId}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(driverTransportOrdersRepositoryProvider);
      final local = ref.read(driverOrdersLocalDataSourceProvider);

      await repo.unassign(id: orderId);
      await local.clearCurrent();
      ref.invalidate(currentDriverOrderProvider);
    });
  }
}
