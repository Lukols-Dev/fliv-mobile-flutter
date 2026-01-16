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

  LocationIndicator? _locationIndicator;
  GeoCoordinates? _prevCoordsForBearing;

  GeoCoordinates? _lastUserCoordinates;

  Route? _currentRoute;
  Route? get currentRoute => _currentRoute;

  List<GeoCoordinates> _lastDispatcherStops = const [];
  GeoCoordinates? _lastStartUsed;

  Timer? _followTimer;
  bool get isFollowing => _followTimer != null;
  bool get canStartNavigation => _currentRoute != null;

  static const _followTick = Duration(seconds: 2);

  // ----------------------------
  // LIFECYCLE MAPY
  // ----------------------------

  void onMapCreated(HereMapController hereMapController) {
    _map = hereMapController;

    try {
      _routingEngine ??= RoutingEngine();
    } on InstantiationException {
      // ignore: avoid_print
      print('RoutingEngine init failed.');
    }

    // fallback kamera
    final mapMeasureZoom = MapMeasure(MapMeasureKind.distanceInMeters, 8000);
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

      // włącz LocationIndicator na tej mapie
      _ensureLocationIndicatorEnabled();

      // pokaż usera
      unawaited(refreshAndCenter());

      // jeśli była trasa wyznaczona wcześniej, odtwórz ją wizualnie na nowej mapie
      _restoreVisualsIfNeeded();
    });
  }

  /// Wywołuj w dispose() ekranu: ekran znika => mapa znika.
  /// Nie zabijamy nawigacji, tylko odpinamy mapę.
  void detachMap() {
    _locationIndicator?.disable();
    _locationIndicator = null;

    _map = null;

    // te obiekty należały do poprzedniej mapy — nie da się ich przenieść
    _routePolylines.clear();
    _stopCircles.clear();
  }

  void _restoreVisualsIfNeeded() {
    final map = _map;
    if (map == null) return;

    // odtwórz wskaźnik usera jeśli mamy coords
    final coords = _lastUserCoordinates;
    if (coords != null) {
      _updateHereLocationIndicator(coords);
    }

    // odtwórz trasę
    final route = _currentRoute;
    if (route != null) {
      _showRouteOnMap(route);

      // odtwórz stop points
      final start = _lastStartUsed;
      if (start != null) {
        _drawStops(start, _lastDispatcherStops);
      }

      _animateToRoute(route);
    }
  }

  // ----------------------------
  // ROUTING
  // ----------------------------

  Future<void> calculateRouteOnDemand({
    required List<GeoCoordinates> dispatcherStops,
  }) async {
    final map = _map;
    final routingEngine = _routingEngine;
    if (routingEngine == null) return;
    if (dispatcherStops.isEmpty) return;

    // START: zawsze GPS kierowcy
    final start = await _getUserCoordinates();
    _lastUserCoordinates = start;
    _lastStartUsed = start;

    _lastDispatcherStops = List<GeoCoordinates>.from(dispatcherStops);

    // wyczyść tylko rysunki/trasę na mapie (ale zostaw follow timer)
    _clearRouteAndStops();

    _ensureLocationIndicatorEnabled();
    _updateHereLocationIndicator(start);

    // narysuj stop points (start + stops)
    _drawStops(start, dispatcherStops);

    final waypoints = <Waypoint>[
      Waypoint.withDefaults(start),
      ...dispatcherStops.map(Waypoint.withDefaults),
    ];

    final carOptions = CarOptions()
      ..routeOptions.enableTolls = true
      ..routeOptions.enableRouteHandle = true
      ..routeOptions.trafficOptimizationMode =
          TrafficOptimizationMode.timeDependent;

    final completer = Completer<void>();

    routingEngine.calculateCarRoute(waypoints, carOptions, (
      RoutingError? error,
      List<Route>? routes,
    ) {
      if (error != null || routes == null || routes.isEmpty) {
        // ignore: avoid_print
        print('Route error: ${error?.name}');
        _setCurrentRoute(null);
        completer.complete();
        return;
      }

      final route = routes.first;
      _setCurrentRoute(route);

      // pokaż na mapie (jeśli mapa akurat istnieje)
      if (_map != null) {
        _showRouteOnMap(route);
        _animateToRoute(route);
      }

      completer.complete();
    });

    await completer.future;
  }

  void _drawStops(GeoCoordinates start, List<GeoCoordinates> stops) {
    final map = _map;
    if (map == null) return;

    // start kierowcy (niebieski)
    _addStopCircle(start, const Color.fromARGB(255, 59, 130, 246));

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

  // ----------------------------
  // FOLLOW / START-STOP
  // ----------------------------

  void startFollowing() {
    if (_followTimer != null) return;

    _followTimer = Timer.periodic(_followTick, (_) async {
      try {
        final coords = await _getUserCoordinates();
        _lastUserCoordinates = coords;

        // jeśli mapa jest — aktualizuj wskaźnik + kamerę
        if (_map != null) {
          _ensureLocationIndicatorEnabled();
          _updateHereLocationIndicator(coords);

          final measure = MapMeasure(MapMeasureKind.distanceInMeters, 900);
          _map!.camera.lookAtPointWithMeasure(coords, measure);
        }
      } catch (_) {
        // ignorujemy chwilowe błędy GPS
      }
    });

    notifyListeners();
  }

  void stopFollowing() {
    _followTimer?.cancel();
    _followTimer = null;
    notifyListeners();
  }

  // ----------------------------
  // MAP HELPERS
  // ----------------------------

  Future<void> refreshAndCenter() async {
    final map = _map;
    if (map == null) return;

    final coords = await _getUserCoordinates();
    _lastUserCoordinates = coords;

    _ensureLocationIndicatorEnabled();
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
      final polyline = MapPolyline.withRepresentation(
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

      map.mapScene.addMapPolyline(polyline);
      _routePolylines.add(polyline);
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

  void _clearRouteAndStops() {
    final map = _map;
    if (map == null) {
      _routePolylines.clear();
      _stopCircles.clear();
      return;
    }

    for (final p in _routePolylines) {
      map.mapScene.removeMapPolyline(p);
    }
    _routePolylines.clear();

    for (final c in _stopCircles) {
      map.mapScene.removeMapPolygon(c);
    }
    _stopCircles.clear();

    _setCurrentRoute(
      _currentRoute,
    ); // nie ruszamy route obiektu, tylko odświeżamy UI
  }

  void _ensureLocationIndicatorEnabled() {
    final map = _map;
    if (map == null) return;

    _locationIndicator ??= LocationIndicator()
      ..locationIndicatorStyle = LocationIndicatorIndicatorStyle.navigation;

    _locationIndicator!.enable(map);
  }

  void _updateHereLocationIndicator(GeoCoordinates coords) {
    final map = _map;
    if (map == null) return;

    double bearing = 0.0;
    final prev = _prevCoordsForBearing;
    if (prev != null) {
      bearing = _bearingDegrees(from: prev, to: coords);
    }
    _prevCoordsForBearing = coords;

    final location = Location.withCoordinates(coords)
      ..time = DateTime.now()
      ..bearingInDegrees = bearing;

    _locationIndicator?.updateLocation(location);
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
    _followTimer?.cancel();
    _followTimer = null;

    _locationIndicator?.disable();
    _locationIndicator = null;

    super.dispose();
  }
}
