import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/driver_transport_orders_repository_impl.dart';
import '../domain/driver_transport_order_details.dart';

final driverOrderDetailsProvider =
    FutureProvider.family<DriverTransportOrderDetails, String>((ref, id) async {
      final repo = ref.read(driverTransportOrdersRepositoryProvider);
      return repo.getById(id: id);
    });
