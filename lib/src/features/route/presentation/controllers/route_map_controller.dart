import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:here_sdk/animation.dart' as here;
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/routing.dart';
import 'package:mobile/src/core/location/location_controller.dart';

class RouteMapController extends ChangeNotifier {
  RouteMapController(this._ref);

  final Ref _ref;

  HereMapController? _map;
  RoutingEngine? _routingEngine;

  final List<MapPolygon> _stopCircles = [];
  final List<MapPolyline> _routePolylines = [];

  // Zamiast MapPolygon "kółka" używamy defaultowego HERE LocationIndicator (kropka/strzałka)
  LocationIndicator? _locationIndicator;
  GeoCoordinates? _prevCoordsForBearing;

  GeoCoordinates? _lastUserCoordinates;

  Route? _currentRoute;
  Route? get currentRoute => _currentRoute;

  void onMapCreated(HereMapController hereMapController) {
    _map = hereMapController;

    try {
      _routingEngine = RoutingEngine();
    } on InstantiationException {
      // ignore: avoid_print
      print('RoutingEngine init failed.');
    }

    const double distanceToEarthInMeters = 8000;
    final mapMeasureZoom = MapMeasure(
      MapMeasureKind.distanceInMeters,
      distanceToEarthInMeters,
    );

    hereMapController.camera.lookAtPointWithMeasure(
      GeoCoordinates(52.2297, 21.0122),
      mapMeasureZoom,
    );

    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay, (
      MapError? error,
    ) {
      if (error != null) {
        // ignore: avoid_print
        print('Map scene not loaded. MapError: ${error.toString()}');
        return;
      }

      // Włącz defaultowy wskaźnik pozycji (strzałka kierunku)
      _locationIndicator ??= LocationIndicator()
        ..locationIndicatorStyle = LocationIndicatorIndicatorStyle.navigation;
      _locationIndicator!.enable(hereMapController);

      unawaited(refreshAndCenter());
    });
  }

  /// NAJWAŻNIEJSZE: trasa jest zawsze:
  /// GPS kierowcy (START) -> punkty od dyspozytora (P1..Pn)
  Future<void> buildRouteFromDriverToStops({
    required List<GeoCoordinates> stops,
    bool drawStops = true,
  }) async {
    final map = _map;
    final routingEngine = _routingEngine;
    if (map == null || routingEngine == null) return;
    if (stops.isEmpty) return;

    // START zawsze świeży GPS kierowcy
    final driverStart = await _getUserCoordinates();
    _lastUserCoordinates = driverStart;

    _clearRouteAndStops(keepUser: true);

    if (drawStops) {
      // start kierowcy (niebieski)
      _addStopCircle(driverStart, const Color.fromARGB(255, 59, 130, 246));

      // punkty dyspozytora (pomarańczowe), ostatni czerwony
      for (int i = 0; i < stops.length; i++) {
        final isLast = i == stops.length - 1;
        _addStopCircle(
          stops[i],
          isLast
              ? const Color(0xFFEF4444)
              : const Color.fromARGB(255, 246, 93, 59),
        );
      }
    }

    final waypoints = <Waypoint>[
      Waypoint.withDefaults(driverStart),
      ...stops.map(Waypoint.withDefaults),
    ];

    final carOptions = CarOptions()
      ..routeOptions.enableTolls = true
      ..routeOptions.trafficOptimizationMode =
          TrafficOptimizationMode.timeDependent;

    final completer = Completer<void>();

    routingEngine.calculateCarRoute(waypoints, carOptions, (
      RoutingError? routingError,
      List<Route>? routeList,
    ) {
      if (routingError != null || routeList == null || routeList.isEmpty) {
        // ignore: avoid_print
        print('Route error: ${routingError?.name}');
        completer.complete();
        return;
      }

      final route = routeList.first;
      _setCurrentRoute(route);

      _showRouteOnMap(route);
      _animateToRoute(route);

      completer.complete();
    });

    await completer.future;
  }

  Future<void> refreshAndCenter() async {
    final map = _map;
    if (map == null) return;

    final coords = await _getUserCoordinates();
    _lastUserCoordinates = coords;

    _updateHereLocationIndicator(coords);

    final measure = MapMeasure(MapMeasureKind.distanceInMeters, 1200);
    map.camera.lookAtPointWithMeasure(coords, measure);
  }

  Future<GeoCoordinates> _getUserCoordinates() async {
    final loc = await _ref
        .read(locationControllerProvider.notifier)
        .getCurrent();
    return GeoCoordinates(loc.lat, loc.lon);
  }

  void _setCurrentRoute(Route? route) {
    _currentRoute = route;
    notifyListeners();
  }

  void _showRouteOnMap(Route route) {
    final map = _map;
    if (map == null) return;

    const double widthInPixels = 16;

    try {
      final routeMapPolyline = MapPolyline.withRepresentation(
        route.geometry,
        MapPolylineSolidRepresentation(
          MapMeasureDependentRenderSize.withSingleSize(
            RenderSizeUnit.pixels,
            widthInPixels,
          ),
          const Color.fromARGB(170, 0, 79, 69),
          LineCap.round,
        ),
      );

      map.mapScene.addMapPolyline(routeMapPolyline);
      _routePolylines.add(routeMapPolyline);
    } on MapPolylineRepresentationInstantiationException catch (e) {
      // ignore: avoid_print
      print('MapPolylineRepresentation error: ${e.error.name}');
    } on MapMeasureDependentRenderSizeInstantiationException catch (e) {
      // ignore: avoid_print
      print('RenderSize error: ${e.error.name}');
    }
  }

  void _animateToRoute(Route route) {
    final map = _map;
    if (map == null) return;

    final origin = Point2D(40, 40);
    final sizeInPixels = Size2D(
      map.viewportSize.width - 80,
      map.viewportSize.height - 220,
    );
    final viewRect = Rectangle2D(origin, sizeInPixels);

    final update =
        MapCameraUpdateFactory.lookAtAreaWithGeoOrientationAndViewRectangle(
          route.boundingBox,
          GeoOrientationUpdate(0.0, 0.0),
          viewRect,
        );

    final animation =
        MapCameraAnimationFactory.createAnimationFromUpdateWithEasing(
          update,
          const Duration(milliseconds: 900),
          here.Easing(here.EasingFunction.inCubic),
        );

    map.camera.startAnimation(animation);
  }

  void _addStopCircle(GeoCoordinates coords, Color color) {
    final map = _map;
    if (map == null) return;

    const double radiusMeters = 28;

    final geoCircle = GeoCircle(coords, radiusMeters);
    final geoPolygon = GeoPolygon.withGeoCircle(geoCircle);
    final circle = MapPolygon(geoPolygon, color);

    map.mapScene.addMapPolygon(circle);
    _stopCircles.add(circle);
  }

  void _clearRouteAndStops({bool keepUser = true}) {
    final map = _map;
    if (map == null) return;

    for (final p in _routePolylines) {
      map.mapScene.removeMapPolyline(p);
    }
    _routePolylines.clear();

    for (final c in _stopCircles) {
      map.mapScene.removeMapPolygon(c);
    }
    _stopCircles.clear();

    if (!keepUser) {
      _locationIndicator?.disable();
      _locationIndicator = null;
      _prevCoordsForBearing = null;
      _lastUserCoordinates = null;
    }

    _setCurrentRoute(null);
  }

  /// Defaultowy HERE wskaźnik lokalizacji z kierunkiem (strzałka)
  /// Bearing liczony z ruchu (prev->current) jako fallback.
  void _updateHereLocationIndicator(GeoCoordinates coords) {
    final map = _map;
    if (map == null) return;

    _locationIndicator ??= LocationIndicator()
      ..locationIndicatorStyle = LocationIndicatorIndicatorStyle.navigation;

    // enable jest bezpieczne do wielokrotnego wywołania
    _locationIndicator!.enable(map);

    double bearing = 0.0;
    final prev = _prevCoordsForBearing;
    if (prev != null) {
      bearing = _bearingDegrees(from: prev, to: coords);
    }
    _prevCoordsForBearing = coords;

    final location = Location.withCoordinates(coords)
      ..time = DateTime.now()
      ..bearingInDegrees = bearing;

    _locationIndicator!.updateLocation(location);
  }

  double _bearingDegrees({
    required GeoCoordinates from,
    required GeoCoordinates to,
  }) {
    final lat1 = from.latitude * (math.pi / 180.0);
    final lon1 = from.longitude * (math.pi / 180.0);
    final lat2 = to.latitude * (math.pi / 180.0);
    final lon2 = to.longitude * (math.pi / 180.0);

    final dLon = lon2 - lon1;

    final y = math.sin(dLon) * math.cos(lat2);
    final x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    var brng = math.atan2(y, x) * (180.0 / math.pi);
    brng = (brng + 360.0) % 360.0;
    return brng;
  }

  @override
  void dispose() {
    _locationIndicator?.disable();
    _locationIndicator = null;
    super.dispose();
  }
}
