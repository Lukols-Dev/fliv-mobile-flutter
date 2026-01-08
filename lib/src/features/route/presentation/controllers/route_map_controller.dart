import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';

import 'package:mobile/src/core/location/location_controller.dart';

final routeMapControllerProvider = Provider.autoDispose<RouteMapController>((
  ref,
) {
  final c = RouteMapController(ref);
  ref.onDispose(c.dispose);
  return c;
});

class RouteMapController {
  RouteMapController(this._ref);

  final Ref _ref;

  HereMapController? _map;
  LocationIndicator? _locationIndicator;
  GeoCoordinates? _lastUserCoords;

  void onMapCreated(HereMapController hereMapController) {
    _map = hereMapController;

    // Start camera (Berlin like example)
    const double distanceToEarthInMeters = 8000;
    final mapMeasureZoom = MapMeasure(
      MapMeasureKind.distanceInMeters,
      distanceToEarthInMeters,
    );

    hereMapController.camera.lookAtPointWithMeasure(
      GeoCoordinates(52.530932, 13.384915),
      mapMeasureZoom,
    );

    // Load scene
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay, (
      MapError? error,
    ) {
      if (error != null) {
        // TODO: change to logger/sentry
        // ignore: avoid_print
        print('Map scene not loaded. MapError: ${error.toString()}');
        return;
      }

      _ensureLocationIndicatorEnabled();

      // Od razu spróbuj pobrać i pokazać usera + wycentrować
      Future.microtask(() async {
        try {
          await refreshAndCenter();
        } catch (_) {
          // brak permisji / brak GPS / itd. -> zostajemy na domyślnym widoku
        }
      });
    });
  }

  void _ensureLocationIndicatorEnabled() {
    if (_map == null) return;
    if (_locationIndicator != null) return;

    final li = LocationIndicator()
      ..locationIndicatorStyle = LocationIndicatorIndicatorStyle.pedestrian;

    li.enable(_map!);
    _locationIndicator = li;
  }

  /// Pobierz aktualną lokalizację (z Twojego locationControllerProvider),
  /// pokaż na mapie i wycentruj kamerę.
  Future<void> refreshAndCenter() async {
    final map = _map;
    if (map == null) return;

    _ensureLocationIndicatorEnabled();

    final loc = await _ref
        .read(locationControllerProvider.notifier)
        .getCurrent();

    final coords = GeoCoordinates(loc.lat, loc.lon);
    _lastUserCoords = coords;

    final hereLoc = Location.withCoordinates(coords)..time = DateTime.now();
    _locationIndicator?.updateLocation(hereLoc);

    _flyTo(coords);
  }

  void centerOnLastKnown() {
    final coords = _lastUserCoords;
    if (coords == null) return;
    _flyTo(coords);
  }

  void _flyTo(GeoCoordinates coords) {
    final map = _map;
    if (map == null) return;

    final update = GeoCoordinatesUpdate.fromGeoCoordinates(coords);
    final animation = MapCameraAnimationFactory.flyTo(
      update,
      1, // bowFactor
      const Duration(milliseconds: 900),
    );

    map.camera.startAnimation(animation);
  }

  void dispose() {
    _locationIndicator?.disable();
    _locationIndicator = null;
    _map = null;
    _lastUserCoords = null;
  }
}
