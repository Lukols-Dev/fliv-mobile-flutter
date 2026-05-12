import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:here_sdk/animation.dart' as here;
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/navigation.dart';
import 'package:here_sdk/routing.dart';
import 'package:here_sdk/transport.dart';
import 'package:mobile/src/core/location/location_controller.dart';
import 'package:mobile/src/core/location/location_service.dart';
import 'package:mobile/src/features/orders/domain/driver_transport_order_details.dart';
import 'package:mobile/src/features/route/domain/dispatcher_route_polyline_decoder.dart';

class RouteMapController extends ChangeNotifier {
  RouteMapController(this._ref);
  final Ref _ref;

  // TODO: Tymczasowa lokalizacja drivera na moment testow podgladu mapy.
  static final GeoCoordinates _temporaryDriverLocation = GeoCoordinates(
    52.201271,
    20.631585,
  );
  static const bool _useTemporaryDriverLocation = true;

  HereMapController? _map;
  RoutingEngine? _routingEngine;
  VisualNavigator? _visualNavigator;
  bool _mapSceneLoaded = false;

  final List<MapPolygon> _stopCircles = [];
  final List<MapPolyline> _routePolylines = [];

  LocationIndicator? _locationIndicator;
  GeoCoordinates? _prevCoordsForBearing;

  GeoCoordinates? _lastUserCoordinates;

  Route? _currentRoute;
  Route? get currentRoute => _currentRoute;

  final DispatcherRoutePolylineDecoder _dispatcherRoutePolylineDecoder =
      const DispatcherRoutePolylineDecoder();
  DriverTransportOrderRoutePlan? _lastDispatcherRoutePlan;
  List<DriverTransportOrderRoutePoint> _lastDispatcherRoutePoints = const [];
  GeoBox? _lastDispatcherRouteBoundingBox;
  int _dispatcherPreviewFitToken = 0;

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

  bool _isCalculating = false;
  bool get isCalculating => _isCalculating;

  bool get isFollowing => _positionSub != null;
  bool get canStartNavigation => _currentRoute != null;

  // ----------------------------
  // LIFECYCLE MAPY
  // ----------------------------

  void onMapCreated(HereMapController hereMapController) {
    _map = hereMapController;
    _mapSceneLoaded = false;
    _enableMapGestures(hereMapController);

    try {
      _routingEngine ??= RoutingEngine();
    } on InstantiationException {
      // ignore: avoid_print
      print('RoutingEngine init failed.');
    }

    // fallback kamera
    final mapMeasureZoom = MapMeasure(MapMeasureKind.distanceInMeters, 8000);
    hereMapController.camera.lookAtPointWithMeasure(
      _temporaryDriverLocation,
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
      _mapSceneLoaded = true;

      if (isFollowing) {
        _visualNavigator?.startRendering(hereMapController);
        return;
      }

      if (_lastDispatcherRoutePlan != null) {
        _restoreVisualsIfNeeded();
        return;
      }

      // włącz LocationIndicator na tej mapie
      _ensureLocationIndicatorEnabled();

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
    _mapSceneLoaded = false;
    _dispatcherPreviewFitToken++;

    // te obiekty należały do poprzedniej mapy — nie da się ich przenieść
    _routePolylines.clear();
    _stopCircles.clear();
  }

  void _enableMapGestures(HereMapController hereMapController) {
    for (final gestureType in GestureType.values) {
      hereMapController.gestures.enableDefaultAction(gestureType);
    }
  }

  void _restoreVisualsIfNeeded() {
    final map = _map;
    if (map == null) return;

    final dispatcherPlan = _lastDispatcherRoutePlan;
    if (dispatcherPlan != null) {
      final route = _currentRoute;
      final dispatcherBox = _drawDispatcherRoutePreview(
        dispatcherPlan,
        fitCamera: route == null,
      );

      if (route != null) {
        _showApproachRouteOnMap(route);
        final start = _lastStartUsed;
        if (start != null) {
          _addStopCircle(start, const Color.fromARGB(255, 59, 130, 246));
        }
        _fitApproachAndDispatcherRoute(
          approachRoute: route,
          dispatcherBox: dispatcherBox,
        );
      }
      return;
    }

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

  void showDispatcherRoutePreview({
    required DriverTransportOrderRoutePlan routePlan,
    required List<DriverTransportOrderRoutePoint> routePoints,
  }) {
    if (isFollowing) {
      stopFollowing();
    }

    _visualNavigator?.route = null;
    _visualNavigator?.stopRendering();

    _locationIndicator?.disable();
    _locationIndicator = null;

    _currentRoute = null;
    _navigationError = null;
    _navigationInstruction = null;
    _remainingDistanceInMeters = null;
    _remainingDuration = null;
    _lastStartUsed = null;
    _lastDispatcherStops = const [];
    _lastDispatcherRoutePlan = routePlan;
    _lastDispatcherRouteBoundingBox = null;
    _lastDispatcherRoutePoints = List<DriverTransportOrderRoutePoint>.from(
      routePoints,
    );

    _clearRouteAndStops();
    if (_mapSceneLoaded) {
      _drawDispatcherRoutePreview(routePlan);
    }
    notifyListeners();
  }

  void clearDispatcherRoutePreview() {
    _lastDispatcherRoutePlan = null;
    _lastDispatcherRoutePoints = const [];
    _lastDispatcherRouteBoundingBox = null;
    _currentRoute = null;
    _dispatcherPreviewFitToken++;
    _navigationError = null;
    _navigationInstruction = null;
    _remainingDistanceInMeters = null;
    _remainingDuration = null;
    _clearRouteAndStops();
    notifyListeners();
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

    _isCalculating = true;
    notifyListeners();

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
      _isCalculating = false;

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

  Future<void> calculateApproachRouteToFirstStop({
    required GeoCoordinates firstStop,
    required DriverTransportOrderRoutePlan routePlan,
  }) async {
    if (isFollowing) {
      stopFollowing();
    }

    final routingEngine = _routingEngine;
    if (_map == null) return;
    if (routingEngine == null) return;

    _isCalculating = true;
    notifyListeners();

    final start = await _getUserCoordinates();
    _lastUserCoordinates = start;
    _lastStartUsed = start;
    _lastDispatcherStops = [firstStop];
    _navigationError = null;
    _navigationInstruction = null;
    _remainingDistanceInMeters = null;
    _remainingDuration = null;

    _clearRouteAndStops();

    final dispatcherBox = _drawDispatcherRoutePreview(
      routePlan,
      fitCamera: false,
    );
    _addStopCircle(start, const Color.fromARGB(255, 59, 130, 246));
    _ensureLocationIndicatorEnabled();
    _updateHereLocationIndicator(start);

    final waypoints = <Waypoint>[
      Waypoint.withDefaults(start),
      Waypoint.withDefaults(firstStop),
    ];

    final completer = Completer<void>();
    final CalculateRouteCallback callback =
        (RoutingError? error, List<Route>? routes) {
          _isCalculating = false;

          if (error != null || routes == null || routes.isEmpty) {
            // ignore: avoid_print
            print('Approach route error: ${error?.name}');
            _navigationError =
                error?.name ?? 'Approach route calculation failed';
            _setCurrentRoute(null);
            completer.complete();
            return;
          }

          final route = routes.first;
          _setCurrentRoute(route);

          if (_map != null) {
            _showApproachRouteOnMap(route);
            _fitApproachAndDispatcherRoute(
              approachRoute: route,
              dispatcherBox: dispatcherBox,
            );
          }

          completer.complete();
        };

    final profile = routePlan.routingProfile;
    if (profile.transportMode.toLowerCase() == 'car') {
      routingEngine.calculateCarRoute(
        waypoints,
        _buildCarOptions(profile),
        callback,
      );
    } else {
      routingEngine.calculateTruckRoute(
        waypoints,
        _buildTruckOptions(profile, routePlan.vehicleSpec),
        callback,
      );
    }

    await completer.future;
  }

  CarOptions _buildCarOptions(DriverRouteRoutingProfile profile) {
    return CarOptions()
      ..routeOptions = _buildRouteOptions(profile)
      ..avoidanceOptions = _buildAvoidanceOptions(profile);
  }

  TruckOptions _buildTruckOptions(
    DriverRouteRoutingProfile profile,
    DriverRouteVehicleSpec? vehicleSpec,
  ) {
    return TruckOptions()
      ..routeOptions = _buildRouteOptions(profile)
      ..avoidanceOptions = _buildAvoidanceOptions(profile)
      ..truckSpecifications = _buildTruckSpecifications(vehicleSpec)
      ..hazardousMaterials = _hazardousMaterials(vehicleSpec);
  }

  RouteOptions _buildRouteOptions(DriverRouteRoutingProfile profile) {
    return RouteOptions.withDefaults()
      ..enableRouteHandle = true
      ..optimizationMode = profile.routingMode.toLowerCase() == 'short'
          ? OptimizationMode.shortest
          : OptimizationMode.fastest
      ..trafficOptimizationMode =
          profile.trafficMode.toLowerCase() == 'disabled'
          ? TrafficOptimizationMode.disabled
          : TrafficOptimizationMode.timeDependent;
  }

  AvoidanceOptions _buildAvoidanceOptions(DriverRouteRoutingProfile profile) {
    final roadFeatures = <RoadFeatures>[];
    if (profile.avoidTolls) roadFeatures.add(RoadFeatures.tollRoad);
    if (profile.avoidFerries) roadFeatures.add(RoadFeatures.ferry);
    if (profile.avoidMotorways) {
      roadFeatures.add(RoadFeatures.controlledAccessHighway);
    }

    return AvoidanceOptions()..roadFeatures = roadFeatures;
  }

  TruckSpecifications _buildTruckSpecifications(
    DriverRouteVehicleSpec? vehicleSpec,
  ) {
    if (vehicleSpec == null) return TruckSpecifications();

    int? positive(int? value) {
      if (value == null || value <= 0) return null;
      return value;
    }

    return TruckSpecifications()
      ..heightInCentimeters = positive(vehicleSpec.heightCm)
      ..widthInCentimeters = positive(vehicleSpec.widthCm)
      ..lengthInCentimeters = positive(vehicleSpec.lengthCm)
      ..currentWeightInKilograms = positive(vehicleSpec.currentWeightKg)
      ..grossWeightInKilograms = positive(vehicleSpec.grossWeightKg)
      ..weightPerAxleInKilograms = positive(vehicleSpec.weightPerAxleKg)
      ..axleCount = positive(vehicleSpec.axleCount)
      ..trailerCount = positive(vehicleSpec.trailerCount);
  }

  List<HazardousMaterial> _hazardousMaterials(
    DriverRouteVehicleSpec? vehicleSpec,
  ) {
    if (vehicleSpec == null) return const [];

    return vehicleSpec.hazardousGoods
        .map(
          (value) => switch (value) {
            'explosive' => HazardousMaterial.explosive,
            'gas' => HazardousMaterial.gas,
            'flammable' => HazardousMaterial.flammable,
            'combustible' => HazardousMaterial.combustible,
            'organic' => HazardousMaterial.organic,
            'poison' => HazardousMaterial.poison,
            'radioactive' => HazardousMaterial.radioactive,
            'corrosive' => HazardousMaterial.corrosive,
            'poisonousInhalation' => HazardousMaterial.poisonousInhalation,
            'harmfulToWater' => HazardousMaterial.harmfulToWater,
            'other' => HazardousMaterial.other,
            _ => null,
          },
        )
        .whereType<HazardousMaterial>()
        .toList(growable: false);
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
      ..speedInMetersPerSecond = position.speed.isFinite
          ? position.speed
          : null;

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

  Future<void> refreshAndCenter({
    bool allowDuringDispatcherPreview = true,
  }) async {
    if (isFollowing) return;
    if (!allowDuringDispatcherPreview && _lastDispatcherRoutePlan != null) {
      return;
    }

    final map = _map;
    if (map == null) return;

    final coords = await _getUserCoordinates();
    if (!allowDuringDispatcherPreview && _lastDispatcherRoutePlan != null) {
      return;
    }

    _lastUserCoordinates = coords;

    _ensureLocationIndicatorEnabled();
    _updateHereLocationIndicator(coords);

    final measure = MapMeasure(MapMeasureKind.distanceInMeters, 1200);
    map.camera.lookAtPointWithMeasure(coords, measure);
  }

  Future<GeoCoordinates> _getUserCoordinates() async {
    if (_useTemporaryDriverLocation) {
      return _temporaryDriverLocation;
    }

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
    _showGeoPolylineOnMap(route.geometry);
  }

  void _showApproachRouteOnMap(Route route) {
    _showGeoPolylineOnMap(
      route.geometry,
      color: const Color.fromARGB(190, 37, 99, 235),
      widthInPixels: 12,
    );
  }

  void _showPreviewRouteSectionOnMap(List<GeoCoordinates> vertices) {
    if (vertices.length < 2) return;

    try {
      _showGeoPolylineOnMap(GeoPolyline(vertices));
    } on InstantiationException {
      // Invalid preview sections are ignored so other valid sections can render.
    }
  }

  void _showGeoPolylineOnMap(
    GeoPolyline geometry, {
    Color color = const Color.fromARGB(170, 0, 79, 69),
    double widthInPixels = 16,
  }) {
    final map = _map;
    if (map == null) return;

    try {
      final polyline = MapPolyline.withRepresentation(
        geometry,
        MapPolylineSolidRepresentation(
          MapMeasureDependentRenderSize.withSingleSize(
            RenderSizeUnit.pixels,
            widthInPixels,
          ),
          color,
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
    _animateToGeoBox(route.boundingBox);
  }

  void _fitApproachAndDispatcherRoute({
    required Route approachRoute,
    GeoBox? dispatcherBox,
  }) {
    final boxes = <GeoBox>[
      approachRoute.boundingBox,
      if (dispatcherBox != null) dispatcherBox,
      if (dispatcherBox == null && _lastDispatcherRouteBoundingBox != null)
        _lastDispatcherRouteBoundingBox!,
    ];

    final boundingBox = GeoBox.envelopeGeoBoxes(boxes);
    if (boundingBox != null) {
      _animateToGeoBox(boundingBox);
    }
  }

  void _animateToGeoBox(GeoBox boundingBox) {
    final map = _map;
    if (map == null) return;

    final update =
        MapCameraUpdateFactory.lookAtAreaWithGeoOrientationAndViewRectangle(
          boundingBox,
          GeoOrientationUpdate(0.0, 0.0),
          _routePreviewViewRectangle(map),
        );

    final animation =
        MapCameraAnimationFactory.createAnimationFromUpdateWithEasing(
          update,
          const Duration(milliseconds: 900),
          here.Easing(here.EasingFunction.inCubic),
        );

    map.camera.startAnimation(animation);
  }

  void _lookAtGeoBox(GeoBox boundingBox) {
    final map = _map;
    if (map == null) return;

    map.camera.lookAtAreaWithGeoOrientationAndViewRectangle(
      boundingBox,
      GeoOrientationUpdate(0.0, 0.0),
      _routePreviewViewRectangle(map),
    );
  }

  Rectangle2D _routePreviewViewRectangle(HereMapController map) {
    final origin = Point2D(40, 40);
    final sizeInPixels = Size2D(
      math.max(1.0, map.viewportSize.width - 80),
      math.max(1.0, map.viewportSize.height - 220),
    );
    return Rectangle2D(origin, sizeInPixels);
  }

  GeoBox? _drawDispatcherRoutePreview(
    DriverTransportOrderRoutePlan routePlan, {
    bool fitCamera = true,
  }) {
    final map = _map;
    if (map == null) return null;

    final List<List<RoutePreviewCoordinate>> sections;
    try {
      sections = _dispatcherRoutePolylineDecoder.decodeSections(
        routePlan.polyline,
      );
    } catch (_) {
      _navigationError = 'Route preview is unavailable.';
      notifyListeners();
      return null;
    }
    if (sections.isEmpty) {
      _navigationError = 'Route preview is unavailable.';
      notifyListeners();
      return null;
    }

    final allVertices = <GeoCoordinates>[];
    for (final section in sections) {
      final vertices = section
          .map((point) => GeoCoordinates(point.latitude, point.longitude))
          .toList(growable: false);

      allVertices.addAll(vertices);
      _showPreviewRouteSectionOnMap(vertices);
    }

    _drawDispatcherRouteStops(_lastDispatcherRoutePoints);

    final boundingBox = GeoBox.containingGeoCoordinates(allVertices);
    _lastDispatcherRouteBoundingBox = boundingBox;
    if (boundingBox != null) {
      if (fitCamera) {
        _scheduleDispatcherRouteFit(boundingBox);
      }
    }

    return boundingBox;
  }

  void _scheduleDispatcherRouteFit(GeoBox boundingBox) {
    final token = ++_dispatcherPreviewFitToken;

    void fitIfStillActive() {
      if (_map == null) return;
      if (_lastDispatcherRoutePlan == null) return;
      if (token != _dispatcherPreviewFitToken) return;
      _lookAtGeoBox(boundingBox);
    }

    fitIfStillActive();

    for (final delay in const [
      Duration(milliseconds: 80),
      Duration(milliseconds: 250),
      Duration(milliseconds: 700),
    ]) {
      unawaited(Future<void>.delayed(delay, fitIfStillActive));
    }
  }

  void _drawDispatcherRouteStops(
    List<DriverTransportOrderRoutePoint> routePoints,
  ) {
    final validPoints = routePoints
        .where(_isValidRoutePoint)
        .toList(growable: false);

    for (int i = 0; i < validPoints.length; i++) {
      final isLast = i == validPoints.length - 1;
      _addStopCircle(
        GeoCoordinates(validPoints[i].latitude, validPoints[i].longitude),
        isLast
            ? const Color(0xFFEF4444)
            : const Color.fromARGB(255, 246, 93, 59),
      );
    }
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

  bool _isValidRoutePoint(DriverTransportOrderRoutePoint point) {
    return point.latitude >= -90 &&
        point.latitude <= 90 &&
        point.longitude >= -180 &&
        point.longitude <= 180;
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
