import 'route_event_type.dart';

class ReportRouteEventPayload {
  const ReportRouteEventPayload({required this.type, this.description});

  final RouteEventType type;
  final String? description;
}
