import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/features/route/domain/route_event_type.dart';

import '../domain/report_route_event_payload.dart';
import '../domain/route_events_repository.dart';
import 'route_events_api.dart';
import '../../../core/network/dio_provider.dart';

final routeEventsApiProvider = Provider<RouteEventsApi>((ref) {
  return RouteEventsApi(ref.read(dioProvider));
});

final routeEventsRepositoryProvider = Provider<RouteEventsRepository>((ref) {
  return RouteEventsRepositoryImpl(ref.read(routeEventsApiProvider));
});

class RouteEventsRepositoryImpl implements RouteEventsRepository {
  RouteEventsRepositoryImpl(this._api);
  final RouteEventsApi _api;

  @override
  Future<void> reportEvent({
    required String orderId,
    required ReportRouteEventPayload payload,
  }) async {
    await _api.reportEvent(
      orderId: orderId,
      eventType: payload.type.apiKey,
      description: payload.description,
    );
  }
}
