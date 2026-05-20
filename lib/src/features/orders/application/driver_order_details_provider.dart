import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/connectivity_provider.dart';
import '../../auth/application/auth_controller.dart';
import '../data/driver_orders_local_data_source.dart';
import '../data/driver_transport_orders_repository_impl.dart';
import '../domain/driver_transport_order_details.dart';

final driverOrderDetailsProvider = FutureProvider.family
    .autoDispose<DriverTransportOrderDetails, String>((ref, id) async {
      final isOffline = ref.watch(isOfflineProvider);
      final session = await ref.watch(authControllerProvider.future);
      if (session == null) throw Exception('Not authenticated');

      final repo = ref.read(driverTransportOrdersRepositoryProvider);
      final local = ref.read(driverOrdersLocalDataSourceProvider);

      if (isOffline) {
        final cached = await local.getDetails(id);
        if (cached != null) return cached;
        throw Exception('Offline and no cached order details for id=$id');
      }

      try {
        final details = await repo.getById(id: id);
        await local.upsertDetails(details);
        return details;
      } catch (_) {
        final cached = await local.getDetails(id);
        if (cached != null) return cached;
        rethrow;
      }
    });
