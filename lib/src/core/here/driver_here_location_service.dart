import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:here_sdk/core.dart' as here;
import 'package:here_sdk/location.dart' as here_location;
import 'package:mobile/src/core/location/location_permission_channel.dart';

const driverLocationPermissionMessage =
    'The app needs access to your location to guide you along the route and share your position with the dispatcher after you start the transport order.';
const driverLocationUnavailableMessage =
    'Current location could not be obtained.';
const driverLocationPermissionDeniedForeverMessage =
    'Location permission is disabled. Enable location access in system settings.';
const driverLocationServiceDisabledMessage =
    'Location services are disabled. Turn on location services to use the map.';

final driverHereLocationServiceProvider = Provider<DriverHereLocationService>((
  ref,
) {
  final service = DriverHereLocationService(
    permissionChannel: ref.read(locationPermissionChannelProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});

class DriverHereLocationPermissionException implements Exception {
  const DriverHereLocationPermissionException([
    this.status = AppLocationPermissionStatus.denied,
  ]);

  final AppLocationPermissionStatus status;

  String get message {
    return switch (status) {
      AppLocationPermissionStatus.deniedForever =>
        driverLocationPermissionDeniedForeverMessage,
      AppLocationPermissionStatus.serviceDisabled =>
        driverLocationServiceDisabledMessage,
      _ => driverLocationPermissionMessage,
    };
  }

  @override
  String toString() => message;
}

class DriverHereLocationUnavailableException implements Exception {
  const DriverHereLocationUnavailableException();

  @override
  String toString() => driverLocationUnavailableMessage;
}

abstract class DriverHereLocationReader {
  here.Location? get lastKnownHereLocation;

  here.Location? getLastFreshHereLocation({
    Duration maxAge = const Duration(seconds: 10),
  });

  Future<here.Location> getCurrentHereLocation({
    Duration maxAge = const Duration(seconds: 10),
    Duration timeout = const Duration(seconds: 10),
  });
}

class DriverHereLocationService implements DriverHereLocationReader {
  DriverHereLocationService({required this.permissionChannel});

  final LocationPermissionChannel permissionChannel;

  here_location.LocationEngine? _engine;
  here.LocationListener? _listener;
  bool _listenerAttached = false;
  Future<void>? _starting;
  here.Location? _lastLocation;
  final _locationController = StreamController<here.Location>.broadcast();

  Stream<here.Location> get locationStream => _locationController.stream;

  @override
  here.Location? get lastKnownHereLocation => _latestKnownLocation();

  @override
  here.Location? getLastFreshHereLocation({
    Duration maxAge = const Duration(seconds: 10),
  }) {
    final latest = _latestKnownLocation();
    return _isFresh(latest, maxAge) ? latest : null;
  }

  Future<void> prepare() async {
    if (_engine?.isStarted == true) return;

    _starting ??= _prepare();
    try {
      await _starting;
    } finally {
      _starting = null;
    }
  }

  @override
  Future<here.Location> getCurrentHereLocation({
    Duration maxAge = const Duration(seconds: 10),
    Duration timeout = const Duration(seconds: 10),
  }) async {
    await prepare();

    final latest = getLastFreshHereLocation(maxAge: maxAge);
    if (latest != null) return latest;

    late final StreamSubscription<here.Location> sub;
    final completer = Completer<here.Location>();

    sub = locationStream.listen((location) {
      if (_isFresh(location, maxAge) && !completer.isCompleted) {
        completer.complete(location);
      }
    });

    try {
      return await completer.future.timeout(
        timeout,
        onTimeout: () => throw const DriverHereLocationUnavailableException(),
      );
    } finally {
      await sub.cancel();
    }
  }

  void stop() {
    _engine?.stop();
  }

  void dispose() {
    final engine = _engine;
    final listener = _listener;
    if (engine != null && listener != null && _listenerAttached) {
      engine.removeLocationListener(listener);
    }
    engine?.stop();
    _listener = null;
    _listenerAttached = false;
    _engine = null;
    _locationController.close();
  }

  Future<void> _prepare() async {
    final permission = await _ensurePermissionStatus();
    if (permission != AppLocationPermissionStatus.granted) {
      throw DriverHereLocationPermissionException(permission);
    }

    final engine = _engine ??= here_location.LocationEngine();
    _listener ??= here.LocationListener(_handleLocationUpdated);
    if (!_listenerAttached) {
      engine.addLocationListener(_listener!);
      _listenerAttached = true;
    }

    final confirmation = engine.confirmHEREPrivacyNoticeInclusion();
    if (confirmation == here_location.ConfirmationStatus.notAllowed) {
      throw const DriverHereLocationUnavailableException();
    }

    final status = engine.startWithLocationAccuracy(
      here_location.LocationAccuracy.navigation,
    );

    switch (status) {
      case here_location.LocationEngineStatus.engineStarted:
      case here_location.LocationEngineStatus.alreadyStarted:
      case here_location.LocationEngineStatus.ok:
        return;
      case here_location.LocationEngineStatus.missingPermissions:
      case here_location.LocationEngineStatus.userConsentNotHandled:
        throw const DriverHereLocationPermissionException();
      default:
        throw const DriverHereLocationUnavailableException();
    }
  }

  Future<AppLocationPermissionStatus> _ensurePermissionStatus() async {
    final current = await permissionChannel.check();
    if (current == AppLocationPermissionStatus.granted) return current;

    if (current == AppLocationPermissionStatus.serviceDisabled ||
        current == AppLocationPermissionStatus.deniedForever) {
      return current;
    }

    return permissionChannel.request();
  }

  void _handleLocationUpdated(here.Location location) {
    _lastLocation = location;
    if (!_locationController.isClosed) {
      _locationController.add(location);
    }
  }

  here.Location? _latestKnownLocation() {
    final lastKnown = _engine?.lastKnownLocation;
    final current = _lastLocation;
    if (lastKnown == null) return current;
    if (current == null) {
      _lastLocation = lastKnown;
      return lastKnown;
    }

    final lastKnownTime = lastKnown.time;
    final currentTime = current.time;
    if (lastKnownTime != null &&
        (currentTime == null || lastKnownTime.isAfter(currentTime))) {
      _lastLocation = lastKnown;
      return lastKnown;
    }

    return current;
  }

  bool _isFresh(here.Location? location, Duration maxAge) {
    final recordedAt = location?.time;
    if (recordedAt == null) return false;

    return DateTime.now().difference(recordedAt).inMilliseconds <=
        maxAge.inMilliseconds;
  }
}
