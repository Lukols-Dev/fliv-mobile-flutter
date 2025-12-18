import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/driver_transport_orders_repository_impl.dart';
import '../domain/driver_transport_order.dart';

final currentDriverOrderProvider = FutureProvider<DriverTransportOrder?>((
  ref,
) async {
  final repo = ref.read(driverTransportOrdersRepositoryProvider);
  return repo.getLatest();
});
