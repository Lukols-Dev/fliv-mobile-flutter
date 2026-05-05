import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:here_sdk/animation.dart' as here;
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/navigation.dart';
import 'package:here_sdk/routing.dart';
import 'package:mobile/src/core/location/location_controller.dart';
import 'package:mobile/src/core/location/location_service.dart';

class RouteMapController extends ChangeNotifier {
  RouteMapController(this._ref);
  final Ref _ref;

  HereMapController? _map;
  RoutingEngine? _routingEngine;
  VisualNavigator? _visualNavigator;

  final List<MapPolygon> _stopCircles = [];
  final List<MapPolyline> _routePolylines = [];

  LocationIndicator? _locationIndicator;
  GeoCoordinates? _prevCoordsForBearing;

  GeoCoordinates? _lastUserCoordinates;

  Route? _currentRoute;
  Route? get currentRoute => _currentRoute;

  String? _navigationInstruction;
  String? get navigationInstruction => _navigationInstruction;

  String? _navigationError;
  String? get navigationError => _navigationError;

  int? _remainingDistanceInMeters;
  int? get remainingDistanceInMeters => _remainingDistanceInMeters;

  Duration? _remainingDuration;
  Duration? get remainingDuration => _remainingDuration;

  List<GeoCoordinates> _lastDispatcherStops = const [];
  GeoCoordinates? _lastStartUsed;

  StreamSubscription<geo.Position>? _positionSub;
  RouteProgressListener? _routeProgressListener;
  EventTextListener? _eventTextListener;
  DestinationReachedListener? _destinationReachedListener;

  bool get isFollowing => _positionSub != null;
  bool get canStartNavigation => _currentRoute != null;

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
      if (!isFollowing) {
        unawaited(refreshAndCenter());
      }

      if (isFollowing) {
        _visualNavigator?.startRendering(hereMapController);
        return;
      }

      // jeśli była trasa wyznaczona wcześniej, odtwórz ją wizualnie na nowej mapie
      _restoreVisualsIfNeeded();
    });
  }

  /// Wywołuj w dispose() ekranu: ekran znika => mapa znika.
  /// Nie zabijamy nawigacji, tylko odpinamy mapę.
  void detachMap() {
    _visualNavigator?.stopRendering();

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
    if (isFollowing) {
      stopFollowing();
    }

    final routingEngine = _routingEngine;
    if (_map == null) return;
    if (routingEngine == null) return;
    if (dispatcherStops.isEmpty) return;

    // START: zawsze GPS kierowcy
    final start = await _getUserCoordinates();
    _lastUserCoordinates = start;
    _lastStartUsed = start;

    _lastDispatcherStops = List<GeoCoordinates>.from(dispatcherStops);
    _navigationError = null;
    _navigationInstruction = null;
    _remainingDistanceInMeters = null;
    _remainingDuration = null;

    // wyczyść tylko rysunki/trasę na mapie
    _clearRouteAndStops();

    _ensureLocationIndicatorEnabled();
    _updateHereLocationIndicator(start);

    // narysuj stop points (start + stops)
    _drawStops(start, dispatcherStops);

    final waypoints = <Waypoint>[
      Waypoint.withDefaults(start),
      ...dispatcherStops.map(Waypoint.withDefaults),
    ];

    final truckOptions = TruckOptions()
      ..routeOptions.enableTolls = true
      ..routeOptions.enableRouteHandle = true
      ..routeOptions.trafficOptimizationMode =
          TrafficOptimizationMode.timeDependent;

    final completer = Completer<void>();

    routingEngine.calculateTruckRoute(waypoints, truckOptions, (
      RoutingError? error,
      List<Route>? routes,
    ) {
      if (error != null || routes == null || routes.isEmpty) {
        // ignore: avoid_print
        print('Route error: ${error?.name}');
        _navigationError = error?.name ?? 'Route calculation failed';
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
  // NAVIGATION / START-STOP
  // ----------------------------

  Future<void> startFollowing() async {
    if (_positionSub != null) return;

    final route = _currentRoute;
    if (route == null) {
      throw StateError('Route is not calculated.');
    }

    final visualNavigator = _ensureVisualNavigator();
    visualNavigator.route = route;
    _navigationError = null;
    _navigationInstruction = null;
    _remainingDistanceInMeters = route.lengthInMeters;
    _remainingDuration = route.duration;

    _locationIndicator?.disable();
    _locationIndicator = null;

    final map = _map;
    if (map != null) {
      visualNavigator.startRendering(map);
    }

    final locationService = _ref.read(locationServiceProvider);
    final currentPosition = await locationService.getCurrentPosition();
    _handlePositionUpdate(currentPosition);

    _positionSub = locationService.getPositionStream().listen(
      _handlePositionUpdate,
      onError: (Object e) {
        _navigationError = e.toString();
        notifyListeners();
      },
    );

    notifyListeners();
  }

  void stopFollowing() {
    _positionSub?.cancel();
    _positionSub = null;
    _visualNavigator?.route = null;
    _visualNavigator?.stopRendering();
    notifyListeners();
  }

  VisualNavigator _ensureVisualNavigator() {
    if (_visualNavigator != null) return _visualNavigator!;

    try {
      final visualNavigator = VisualNavigator();

      _routeProgressListener = RouteProgressListener((progress) {
        if (progress.sectionProgress.isNotEmpty) {
          final remaining = progress.sectionProgress.last;
          _remainingDistanceInMeters = remaining.remainingDistanceInMeters;
          _remainingDuration = remaining.remainingDuration;
        }

        final maneuverProgress = progress.maneuverProgress.isNotEmpty
            ? progress.maneuverProgress.first
            : null;
        if (maneuverProgress != null) {
          final maneuver = visualNavigator.getManeuver(
            maneuverProgress.maneuverIndex,
          );
          final text = maneuver?.text;
          if (text != null && text.trim().isNotEmpty) {
            _navigationInstruction = text.trim();
          }
        }

        notifyListeners();
      });

      _eventTextListener = EventTextListener((eventText) {
        if (eventText.text.trim().isNotEmpty) {
          _navigationInstruction = eventText.text.trim();
          notifyListeners();
        }
      });

      _destinationReachedListener = DestinationReachedListener(() {
        stopFollowing();
        _remainingDistanceInMeters = 0;
        _remainingDuration = Duration.zero;
        notifyListeners();
      });

      visualNavigator.routeProgressListener = _routeProgressListener;
      visualNavigator.eventTextListener = _eventTextListener;
      visualNavigator.destinationReachedListener = _destinationReachedListener;

      _visualNavigator = visualNavigator;
      return visualNavigator;
    } on InstantiationException {
      throw StateError('VisualNavigator init failed.');
    }
  }

  void _handlePositionUpdate(
    geo.Position position, {
    bool centerCamera = false,
  }) {
    final coords = GeoCoordinates(position.latitude, position.longitude);
    _lastUserCoordinates = coords;

    final location = Location.withCoordinates(coords)
      ..time = position.timestamp
      ..horizontalAccuracyInMeters = position.accuracy.isFinite
          ? position.accuracy
          : null
      ..bearingInDegrees = position.heading.isFinite ? position.heading : null
      ..speedInMetersPerSecond = position.speed.isFinite ? position.speed : null;

    _visualNavigator?.onLocationUpdated(location);

    final map = _map;
    if (centerCamera && map != null && !isFollowing) {
      final measure = MapMeasure(MapMeasureKind.distanceInMeters, 900);
      map.camera.lookAtPointWithMeasure(coords, measure);
    }
  }

  // ----------------------------
  // MAP HELPERS
  // ----------------------------

  Future<void> refreshAndCenter() async {
    if (isFollowing) return;

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
    _positionSub?.cancel();
    _positionSub = null;
    _visualNavigator?.stopRendering();
    _visualNavigator?.route = null;
    _visualNavigator = null;

    _locationIndicator?.disable();
    _locationIndicator = null;

    super.dispose();
  }
}
