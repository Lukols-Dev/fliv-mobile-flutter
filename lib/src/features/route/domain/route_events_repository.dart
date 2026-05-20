import 'report_route_event_payload.dart';

abstract class RouteEventsRepository {
  Future<void> reportEvent({
    required String orderId,
    required ReportRouteEventPayload payload,
  });
}
