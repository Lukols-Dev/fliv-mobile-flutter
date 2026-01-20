import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/route_events_repository_impl.dart';
import '../domain/report_route_event_payload.dart';

final reportRouteEventControllerProvider =
    AsyncNotifierProvider<ReportRouteEventController, void>(
      ReportRouteEventController.new,
    );

class ReportRouteEventController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> report({
    required String orderId,
    required ReportRouteEventPayload payload,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(routeEventsRepositoryProvider);
      await repo.reportEvent(orderId: orderId, payload: payload);
    });
  }
}
