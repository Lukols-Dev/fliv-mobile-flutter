import 'package:geolocator/geolocator.dart';

class LocationService {
  const LocationService();

  Future<void> ensureServiceAndPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw StateError('Usługi lokalizacji są wyłączone.');
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw StateError('Brak zgody na lokalizację.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw StateError('Lokalizacja zablokowana na stałe w ustawieniach.');
    }
  }

  Future<Position> getCurrentPosition() async {
    await ensureServiceAndPermission();

    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      timeLimit: Duration(seconds: 10),
    );

    return Geolocator.getCurrentPosition(locationSettings: settings);
  }

  Stream<Position> getPositionStream() async* {
    await ensureServiceAndPermission();

    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    yield* Geolocator.getPositionStream(locationSettings: settings);
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }
}
