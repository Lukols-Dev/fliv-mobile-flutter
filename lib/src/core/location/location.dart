import 'package:here_sdk/core.dart' as here;

class AppLocation {
  final double lat;
  final double lon;
  final double? accuracy;
  final DateTime timestamp;

  const AppLocation({
    required this.lat,
    required this.lon,
    required this.timestamp,
    this.accuracy,
  });

  factory AppLocation.fromHereLocation(here.Location location) => AppLocation(
    lat: location.coordinates.latitude,
    lon: location.coordinates.longitude,
    accuracy: location.horizontalAccuracyInMeters,
    timestamp: location.time ?? DateTime.now(),
  );
}
