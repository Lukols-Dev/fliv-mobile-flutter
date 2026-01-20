enum RouteEventType { detour, accident, delay }

extension RouteEventTypeX on RouteEventType {
  String get apiKey => switch (this) {
    RouteEventType.detour => 'INCIDENT_DETOUR',
    RouteEventType.accident => 'INCIDENT_ACCIDENT',
    RouteEventType.delay => 'INCIDENT_DELAY',
  };
}
