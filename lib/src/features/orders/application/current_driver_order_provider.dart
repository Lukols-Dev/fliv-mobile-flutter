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
        // Bound the network call so a slow/unreachable backend cannot keep
        // the home screen spinning up to dio's 20s receive timeout.
        final order =
            await repo.getLatest().timeout(const Duration(seconds: 6));
        if (order != null) {
          await local.upsertCurrent(order);
          return order;
        }
        return local.getCurrent();
      } catch (_) {
        // Timeout or network error: fall back to cache. For a brand-new
        // driver the cache is empty, so this resolves to null ("no order").
        return local.getCurrent();
      }
    });
