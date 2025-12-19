import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/connectivity_provider.dart';
import '../../auth/application/auth_controller.dart';
import '../data/driver_orders_local_data_source.dart';
import '../data/driver_transport_orders_repository_impl.dart';
import '../domain/driver_transport_order.dart';

final currentDriverOrderProvider =
    FutureProvider.autoDispose<DriverTransportOrder?>((ref) async {
      final session = await ref.watch(authControllerProvider.future);
      if (session == null) return null;

      final repo = ref.read(driverTransportOrdersRepositoryProvider);
      final local = ref.read(driverOrdersLocalDataSourceProvider);

      if (ref.read(isOfflineProvider)) {
        return local.getCurrent();
      }

      try {
        final order = await repo.getLatest();
        if (order != null) {
          await local.upsertCurrent(order);
          return order;
        }
        return local.getCurrent();
      } catch (_) {
        final cached = await local.getCurrent();
        if (cached != null) return cached;
        rethrow;
      }
    });
