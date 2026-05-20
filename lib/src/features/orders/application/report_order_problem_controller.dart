import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/features/orders/application/current_driver_order_provider.dart';

import '../../../core/network/connectivity_provider.dart';
import '../data/driver_orders_local_data_source.dart';
import '../data/driver_transport_orders_repository_impl.dart';

final reportOrderProblemControllerProvider =
    AsyncNotifierProvider<ReportOrderProblemController, void>(
      ReportOrderProblemController.new,
    );

class ReportOrderProblemController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> reportProblem({
    required String orderId,
    required String description,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(driverTransportOrdersRepositoryProvider);
      final local = ref.read(driverOrdersLocalDataSourceProvider);

      final isOnline = await ref
          .read(networkStatusControllerProvider.notifier)
          .checkNow(force: true);
      if (!isOnline) {
        throw Exception('Nie można zgłosić problemu w trybie offline');
      }

      final updatedOrder = await repo.reportProblem(
        id: orderId,
        description: description,
      );

      await local.upsertCurrent(updatedOrder);
      ref.invalidate(currentDriverOrderProvider);
    });
  }
}
