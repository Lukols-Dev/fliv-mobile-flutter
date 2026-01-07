import 'package:geolocator/geolocator.dart';

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

  factory AppLocation.fromPosition(Position p) => AppLocation(
    lat: p.latitude,
    lon: p.longitude,
    accuracy: p.accuracy,
    timestamp: p.timestamp,
  );
}
