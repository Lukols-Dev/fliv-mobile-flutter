import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:here_sdk/animation.dart' as here;
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:here_sdk/core.threading.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/routing.dart';
import 'package:mobile/src/core/location/location_controller.dart';

class RouteMapController extends ChangeNotifier {
  RouteMapController(this._ref);

  final Ref _ref;

  HereMapController? _map;
  RoutingEngine? _routingEngine;
  bool _sceneLoaded = false;

  bool _disposed = false;

  // HERE default indicator (kropka + strzałka)
  LocationIndicator? _locationIndicator;
  GeoCoordinates? _prevCoordsForBearing;
  GeoCoordinates? _lastUserCoordinates;

  // route + rendering
  Route? _currentRoute;
  Route? get currentRoute => _currentRoute;

  final List<MapPolygon> _stopCircles = [];
  final List<MapPolyline> _routePolylines = [];
  TaskHandle? _currentRouteTask;

  // follow mode
  Timer? _followTimer;
  bool _isFollowing = false;
  bool get isFollowing => _isFollowing;

  bool get canStartNavigation => _currentRoute != null;

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
      GeoCoordinates(52.2297, 21.0122), // Warsaw fallback
      mapMeasureZoom,
    );

    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay, (
      MapError? error,
    ) {
      if (_disposed) return;

      if (error != null) {
        // ignore: avoid_print
        print('Map scene not loaded. MapError: ${error.toString()}');
        return;
      }

      _sceneLoaded = true;

      _locationIndicator ??= LocationIndicator()
        ..locationIndicatorStyle = LocationIndicatorIndicatorStyle.navigation;
      _locationIndicator!.enable(hereMapController);

      unawaited(refreshAndCenter());
    });
  }

  /// 1) Klik "Wyznacz trasę"
  /// START = GPS kierowcy
  /// STOPS = punkty od dyspozytora (P1..Pn)
  Future<void> calculateRouteOnDemand({
    required List<GeoCoordinates> dispatcherStops,
  }) async {
    if (_disposed) return;
    if (!_sceneLoaded) return;

    final map = _map;
    final routingEngine = _routingEngine;
    if (map == null || routingEngine == null) return;

    if (dispatcherStops.isEmpty) return;

    // cancel previous calculation
    if (_currentRouteTask != null && !_currentRouteTask!.isFinished) {
      _currentRouteTask!.cancel();
      _currentRouteTask = null;
    }

    // Start GPS
    final start = await _safeGetUserCoordinates();
    if (start == null) return;

    _lastUserCoordinates = start;
    _updateHereLocationIndicator(start);

    // clear old route
    _clearRouteAndStops(keepLocationIndicator: true);

    // draw points: start + stops
    _addStopCircle(start, const Color.fromARGB(255, 59, 130, 246));
    for (int i = 0; i < dispatcherStops.length; i++) {
      final isLast = i == dispatcherStops.length - 1;
      _addStopCircle(
        dispatcherStops[i],
        isLast
            ? const Color(0xFFEF4444)
            : const Color.fromARGB(255, 246, 93, 59),
      );
    }

    // Create waypoints - HERE SDK will automatically snap them to nearest roads
    final waypoints = <Waypoint>[
      Waypoint.withDefaults(start),
      ...dispatcherStops.map(Waypoint.withDefaults),
    ];

    // Log waypoints for debugging
    // ignore: avoid_print
    print('Calculating route with ${waypoints.length} waypoints:');
    // ignore: avoid_print
    print('  Start: ${start.latitude}, ${start.longitude}');
    for (int i = 0; i < dispatcherStops.length; i++) {
      final stop = dispatcherStops[i];
      final distanceKm = _distanceInKm(start, stop);
      // ignore: avoid_print
      print(
        '  Stop ${i + 1}: ${stop.latitude}, ${stop.longitude} (distance: ${distanceKm.toStringAsFixed(1)} km)',
      );
    }

    final carOptions = CarOptions();
    carOptions.routeOptions.enableTolls = true;
    carOptions.routeOptions.trafficOptimizationMode =
        TrafficOptimizationMode.timeDependent;
    carOptions.routeOptions.enableRouteHandle = true;

    _setCurrentRoute(null);

    _currentRouteTask = routingEngine.calculateCarRoute(waypoints, carOptions, (
      RoutingError? routingError,
      List<Route>? routeList,
    ) {
      if (_disposed) return;

      if (routingError != null || routeList == null || routeList.isEmpty) {
        // ignore: avoid_print
        print('Route calculation failed:');
        // ignore: avoid_print
        print('  Error: ${routingError?.name ?? 'unknown'}');
        // ignore: avoid_print
        print('  Routes found: ${routeList?.length ?? 0}');
        if (routingError != null) {
          // ignore: avoid_print
          print('  Error details: ${routingError.toString()}');
        }
        _setCurrentRoute(null);
        return;
      }

      final route = routeList.first;
      _setCurrentRoute(route);

      _showRouteOnMap(route);
      _animateToRoute(route);
    });
  }

  /// 2) Klik "Rozpocznij trasę" -> follow mode
  void startFollowing() {
    if (_disposed) return;
    if (_isFollowing) return;

    _isFollowing = true;
    _safeNotify();

    _followTimer?.cancel();
    _followTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (_disposed) return;

      final map = _map;
      if (map == null) return;

      final coords = await _safeGetUserCoordinates();
      if (coords == null) return;

      _lastUserCoordinates = coords;
      _updateHereLocationIndicator(coords);

      // gentle follow
      final measure = MapMeasure(MapMeasureKind.distanceInMeters, 900);
      map.camera.lookAtPointWithMeasure(coords, measure);
    });
  }

  void stopFollowing() {
    _followTimer?.cancel();
    _followTimer = null;

    if (_isFollowing) {
      _isFollowing = false;
      _safeNotify();
    }
  }

  Future<void> refreshAndCenter() async {
    if (_disposed) return;

    final map = _map;
    if (map == null) return;

    final coords = await _safeGetUserCoordinates();
    if (coords == null) return;

    _lastUserCoordinates = coords;
    _updateHereLocationIndicator(coords);

    final measure = MapMeasure(MapMeasureKind.distanceInMeters, 1200);
    map.camera.lookAtPointWithMeasure(coords, measure);
  }

  Future<GeoCoordinates?> _safeGetUserCoordinates() async {
    try {
      final loc = await _ref
          .read(locationControllerProvider.notifier)
          .getCurrent();
      return GeoCoordinates(loc.lat, loc.lon);
    } on TimeoutException catch (e) {
      // ignore: avoid_print
      print('GPS timeout: $e');
      return _lastUserCoordinates;
    } catch (e) {
      // ignore: avoid_print
      print('GPS error: $e');
      return _lastUserCoordinates;
    }
  }

  void _setCurrentRoute(Route? route) {
    _currentRoute = route;
    _safeNotify();
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

  void _clearRouteAndStops({required bool keepLocationIndicator}) {
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

    if (!keepLocationIndicator) {
      _locationIndicator?.disable();
      _locationIndicator = null;
      _prevCoordsForBearing = null;
      _lastUserCoordinates = null;
    }

    _setCurrentRoute(null);
  }

  void _updateHereLocationIndicator(GeoCoordinates coords) {
    final map = _map;
    if (map == null) return;

    _locationIndicator ??= LocationIndicator()
      ..locationIndicatorStyle = LocationIndicatorIndicatorStyle.navigation;
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

  /// Calculate distance between two coordinates in kilometers using Haversine formula
  double _distanceInKm(GeoCoordinates from, GeoCoordinates to) {
    const double earthRadiusKm = 6371.0;

    final lat1Rad = from.latitude * (math.pi / 180.0);
    final lon1Rad = from.longitude * (math.pi / 180.0);
    final lat2Rad = to.latitude * (math.pi / 180.0);
    final lon2Rad = to.longitude * (math.pi / 180.0);

    final dLat = lat2Rad - lat1Rad;
    final dLon = lon2Rad - lon1Rad;

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadiusKm * c;
  }

  void _safeNotify() {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;

    _followTimer?.cancel();
    _followTimer = null;

    if (_currentRouteTask != null && !_currentRouteTask!.isFinished) {
      _currentRouteTask!.cancel();
    }
    _currentRouteTask = null;

    _locationIndicator?.disable();
    _locationIndicator = null;

    super.dispose();
  }
}
