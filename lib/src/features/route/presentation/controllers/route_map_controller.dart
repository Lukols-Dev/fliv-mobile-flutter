import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:here_sdk/animation.dart' as here;
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/navigation.dart';
import 'package:here_sdk/routing.dart';
import 'package:here_sdk/transport.dart';
import 'package:mobile/src/core/config/env.dart';
import 'package:mobile/src/core/here/driver_here_location_service.dart';
import 'package:mobile/src/features/orders/domain/driver_transport_order_details.dart';
import 'package:mobile/src/features/route/data/driver_location_reporting_service.dart';
import 'package:mobile/src/features/route/domain/dispatcher_route_polyline_decoder.dart';

class RouteMapController extends ChangeNotifier {
  RouteMapController(this._ref);
  final Ref _ref;

  static final GeoCoordinates _initialMapCenter = GeoCoordinates(
    52.201271,
    20.631585,
  );
  static const Duration _navigationCameraAutoResumeDelay = Duration(
    seconds: 10,
  );

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
  bool _showCurrentLocationWhenMapReady = false;
  bool _centerCurrentLocationWhenMapReady = false;
  Future<void>? _pendingCurrentLocationUpdate;

  String? _navigationInstruction;
  String? get navigationInstruction => _navigationInstruction;

  ManeuverAction? _nextManeuverAction;
  ManeuverAction? get nextManeuverAction => _nextManeuverAction;

  int? _distanceToNextManeuverMeters;
  int? get distanceToNextManeuverMeters => _distanceToNextManeuverMeters;

  String? _nextRoadName;
  String? get nextRoadName => _nextRoadName;

  List<Lane>? _lanesForNextManeuver;
  List<Lane>? get lanesForNextManeuver => _lanesForNextManeuver;

  SafetyCameraWarning? _safetyCameraWarning;
  SafetyCameraWarning? get safetyCameraWarning => _safetyCameraWarning;

  final List<TruckRestrictionWarning> _activeTruckRestrictions = [];
  List<TruckRestrictionWarning> get activeTruckRestrictions =>
      List.unmodifiable(_activeTruckRestrictions);

  String? _navigationError;
  String? get navigationError => _navigationError;

  double? _currentSpeedLimitKmh;
  double? get currentSpeedLimitKmh => _currentSpeedLimitKmh;

  double? _currentSpeedKmh;
  double? get currentSpeedKmh => _currentSpeedKmh;

  bool _isSpeedExceeded = false;
  bool get isSpeedExceeded => _isSpeedExceeded;

  int? _remainingDistanceInMeters;
  int? get remainingDistanceInMeters => _remainingDistanceInMeters;

  Duration? _remainingDuration;
  Duration? get remainingDuration => _remainingDuration;

  List<GeoCoordinates> _lastDispatcherStops = const [];
  GeoCoordinates? _lastStartUsed;

  StreamSubscription<Location>? _positionSub;
  LocationSimulator? _locationSimulator;
  StreamSubscription<Location>? _mapLocationSub;
  Timer? _navigationCameraResumeTimer;
  RouteProgressListener? _routeProgressListener;
  EventTextListener? _eventTextListener;
  DestinationReachedListener? _destinationReachedListener;
  RouteDeviationListener? _routeDeviationListener;
  MilestoneStatusListener? _milestoneStatusListener;
  SpeedLimitListener? _speedLimitListener;
  SpeedWarningListener? _speedWarningListener;
  ManeuverViewLaneAssistanceListener? _maneuverViewLaneAssistanceListener;
  SafetyCameraWarningListener? _safetyCameraWarningListener;
  TruckRestrictionsWarningListener? _truckRestrictionsWarningListener;

  bool _isRerouting = false;
  bool get isRerouting => _isRerouting;

  int _milestonesReached = 0;
  int get milestonesReached => _milestonesReached;

  String? get nextPointAddress {
    if (_lastDispatcherRoutePoints.isEmpty) return null;
    final sorted = [..._lastDispatcherRoutePoints]
      ..sort((a, b) => a.sequence.compareTo(b.sequence));
    if (_milestonesReached >= sorted.length) return null;
    return sorted[_milestonesReached].address;
  }

  bool _isCalculating = false;
  bool get isCalculating => _isCalculating;

  bool _isCameraTracking = false;
  bool get isCameraTracking => _isCameraTracking;

  bool get isSimulating => _locationSimulator != null;
  bool get isFollowing => _positionSub != null || isSimulating;
  bool get canStartNavigation => _currentRoute != null;

  static const double _autoStartSpeedThresholdKmh = 5.0;
  bool _pendingAutoStart = false;
  bool get pendingAutoStart => _pendingAutoStart;

  void consumeAutoStart() {
    _pendingAutoStart = false;
  }

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
      _initialMapCenter,
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
        _flushPendingCurrentLocationIfNeeded();
        return;
      }

      if (_lastDispatcherRoutePlan != null) {
        _restoreVisualsIfNeeded();
        _flushPendingCurrentLocationIfNeeded();
        return;
      }

      // włącz LocationIndicator na tej mapie
      _ensureLocationIndicatorEnabled();

      // jeśli była trasa wyznaczona wcześniej, odtwórz ją wizualnie na nowej mapie
      _restoreVisualsIfNeeded();
      _flushPendingCurrentLocationIfNeeded();
    });
  }

  void showCurrentLocationWhenReady({bool centerCamera = false}) {
    _showCurrentLocationWhenMapReady = true;
    _centerCurrentLocationWhenMapReady =
        _centerCurrentLocationWhenMapReady || centerCamera;
    _ensureMapLocationUpdates();
    _flushPendingCurrentLocationIfNeeded();
  }

  void _flushPendingCurrentLocationIfNeeded() {
    if (!_showCurrentLocationWhenMapReady) return;
    if (!_mapSceneLoaded || _map == null) return;
    if (_pendingCurrentLocationUpdate != null) return;

    final shouldCenter =
        _centerCurrentLocationWhenMapReady &&
        _lastDispatcherRoutePlan == null &&
        _currentRoute == null &&
        !isFollowing;

    _showCurrentLocationWhenMapReady = false;
    _centerCurrentLocationWhenMapReady = false;

    _pendingCurrentLocationUpdate = _showCurrentLocationOnMap(
      centerCamera: shouldCenter,
    ).whenComplete(() => _pendingCurrentLocationUpdate = null);
  }

  void _ensureMapLocationUpdates() {
    if (_mapLocationSub != null) return;

    final locationService = _ref.read(driverHereLocationServiceProvider);
    _mapLocationSub = locationService.locationStream.listen(
      _handleMapLocationUpdate,
      onError: (Object e) {
        // ignore: avoid_print
        print('Map location stream error: $e');
      },
    );

    unawaited(_showCurrentLocationFromLastKnown());
  }

  void _handleMapLocationUpdate(Location location) {
    if (_map == null || isFollowing) return;

    final coords = location.coordinates;
    _lastUserCoordinates = coords;
    _ensureLocationIndicatorEnabled();
    _updateHereLocationIndicator(coords, bearing: location.bearingInDegrees);

    if (canStartNavigation && !_pendingAutoStart) {
      final speedKmh = (location.speedInMetersPerSecond ?? 0.0) * 3.6;
      if (speedKmh >= _autoStartSpeedThresholdKmh) {
        _pendingAutoStart = true;
      }
    }

    notifyListeners();
  }

  /// Wywołuj w dispose() ekranu: ekran znika => mapa znika.
  /// Nie zabijamy nawigacji, tylko odpinamy mapę.
  void detachMap() {
    _cancelNavigationCameraAutoResume();
    _visualNavigator?.stopRendering();

    _mapLocationSub?.cancel();
    _mapLocationSub = null;
    if (_positionSub == null) {
      _ref.read(driverHereLocationServiceProvider).stop();
    }

    _locationIndicator?.disable();
    _locationIndicator = null;

    _map = null;
    _mapSceneLoaded = false;
    _showCurrentLocationWhenMapReady = false;
    _centerCurrentLocationWhenMapReady = false;
    _pendingCurrentLocationUpdate = null;
    _dispatcherPreviewFitToken++;

    // te obiekty należały do poprzedniej mapy — nie da się ich przenieść
    _routePolylines.clear();
    _stopCircles.clear();
  }

  void _enableMapGestures(HereMapController hereMapController) {
    for (final gestureType in GestureType.values) {
      hereMapController.gestures.enableDefaultAction(gestureType);
    }

    hereMapController.gestures.panListener = PanListener((state, _, __, ___) {
      if (!isFollowing) return;

      if (state == GestureState.begin) {
        _pauseNavigationCameraTracking();
        return;
      }

      if (state == GestureState.update) {
        _cancelNavigationCameraAutoResume();
        return;
      }

      if (state == GestureState.end || state == GestureState.cancel) {
        _scheduleNavigationCameraAutoResume();
      }
    });
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
          _ensureLocationIndicatorEnabled();
          _updateHereLocationIndicator(start);
        }
        _fitApproachAndDispatcherRoute(
          approachRoute: route,
          dispatcherBox: dispatcherBox,
        );
      } else {
        unawaited(_showUserLocationIndicatorWithoutCentering());
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
      _drawStops(_lastDispatcherStops);

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
      unawaited(_showUserLocationIndicatorWithoutCentering());
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
    _locationIndicator?.disable();
    _locationIndicator = null;
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

    // narysuj punkty dyspozytora; start kierowcy pokazuje LocationIndicator.
    _drawStops(dispatcherStops);

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
    List<DriverTransportOrderRoutePoint> routePoints = const [],
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
    _lastDispatcherRoutePoints = List<DriverTransportOrderRoutePoint>.from(routePoints);
    _navigationError = null;
    _navigationInstruction = null;
    _remainingDistanceInMeters = null;
    _remainingDuration = null;

    _clearRouteAndStops();

    final dispatcherBox = _drawDispatcherRoutePreview(
      routePlan,
      fitCamera: false,
    );
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

  void cancelApproachRoute() {
    if (isFollowing) {
      stopFollowing();
    }

    _visualNavigator?.route = null;
    _visualNavigator?.stopRendering();

    _currentRoute = null;
    _navigationError = null;
    _navigationInstruction = null;
    _remainingDistanceInMeters = null;
    _remainingDuration = null;
    _lastStartUsed = null;
    _lastDispatcherStops = const [];

    _clearRouteAndStops();

    final dispatcherPlan = _lastDispatcherRoutePlan;
    if (_mapSceneLoaded && dispatcherPlan != null) {
      _drawDispatcherRoutePreview(dispatcherPlan);
      unawaited(_showUserLocationIndicatorWithoutCentering());
    }

    notifyListeners();
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
      ..enableTolls = true
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

  void _drawStops(List<GeoCoordinates> stops) {
    final map = _map;
    if (map == null) return;

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

  SpeedBasedCameraBehavior _buildNavigationCameraBehavior() {
    final behavior = SpeedBasedCameraBehavior()
      ..normalizedPrincipalPoint = Anchor2D.withHorizontalAndVertical(0.5, 0.65);

    // Reduced tilt and closer zoom vs default 3D profile to push the sky/horizon
    // line above the top edge of the viewport (same effect as Yanosik/Waze).
    behavior.setProfile([
      SpeedBasedCameraBehaviorProfileValue(
        0, 15,   // 0–54 km/h  (city)
        MapMeasure(MapMeasureKind.distanceInMeters, 180),
        45,
      ),
      SpeedBasedCameraBehaviorProfileValue(
        13, 30,  // 47–108 km/h  (extra-urban, overlapping range avoids oscillation)
        MapMeasure(MapMeasureKind.distanceInMeters, 320),
        50,
      ),
      SpeedBasedCameraBehaviorProfileValue(
        28, 80,  // 101–288 km/h  (motorway)
        MapMeasure(MapMeasureKind.distanceInMeters, 520),
        53,
      ),
    ]);

    return behavior;
  }

  Future<void> startFollowing() async {
    if (_positionSub != null) return;

    final route = _currentRoute;
    if (route == null) {
      throw StateError('Route is not calculated.');
    }

    final visualNavigator = _ensureVisualNavigator();
    _cancelNavigationCameraAutoResume();
    visualNavigator.cameraBehavior = _buildNavigationCameraBehavior();
    visualNavigator.route = route;
    _navigationError = null;
    _navigationInstruction = null;
    _nextManeuverAction = null;
    _distanceToNextManeuverMeters = null;
    _nextRoadName = null;
    _lanesForNextManeuver = null;
    _safetyCameraWarning = null;
    _activeTruckRestrictions.clear();
    _currentSpeedKmh = 0.0;
    _currentSpeedLimitKmh = null;
    _isSpeedExceeded = false;
    _remainingDistanceInMeters = route.lengthInMeters;
    _remainingDuration = route.duration;

    _locationIndicator?.disable();
    _locationIndicator = null;
    _milestonesReached = 0;
    _isRerouting = false;
    _isCameraTracking = true;

    final map = _map;
    if (map != null) {
      visualNavigator.startRendering(map);
    }

    if (Env.simulateNavigation) {
      try {
        final options = LocationSimulatorOptions()
          ..speedFactor = Env.simulationSpeedFactor.toDouble()
          ..notificationInterval = const Duration(milliseconds: 500);
        _locationSimulator = LocationSimulator.withRoute(route, options);
        _locationSimulator!.listener = LocationListener((location) {
          _handleHereLocationUpdate(location);
          _ref
              .read(driverLocationReportingServiceProvider)
              .setSimulatedLocation(location);
        });
        _locationSimulator!.start();
      } catch (_) {
        visualNavigator.route = null;
        visualNavigator.stopRendering();
        _locationSimulator = null;
        rethrow;
      }

      notifyListeners();
      return;
    }

    final locationService = _ref.read(driverHereLocationServiceProvider);
    Location? initialLocation;
    try {
      await locationService.prepare();
      initialLocation = locationService.lastKnownHereLocation;
      if (initialLocation != null) {
        _handleHereLocationUpdate(initialLocation);
      }

      _positionSub = locationService.locationStream.listen(
        _handleHereLocationUpdate,
        onError: (Object e) {
          _navigationError = e.toString();
          notifyListeners();
        },
      );
    } catch (_) {
      visualNavigator.route = null;
      visualNavigator.stopRendering();
      rethrow;
    }

    notifyListeners();

    // HERE SDK's SpeedLimitListener may not fire on the first onLocationUpdated
    // call after startRendering. A second update after the widget tree rebuilds
    // ensures the speed limit is shown immediately without waiting for the next
    // GPS stream event.
    final loc = initialLocation ?? locationService.lastKnownHereLocation;
    if (loc != null) {
      Future.microtask(() {
        if (isFollowing) _handleHereLocationUpdate(loc);
      });
    }
  }

  void stopFollowing() {
    _cancelNavigationCameraAutoResume();
    _positionSub?.cancel();
    _positionSub = null;
    _locationSimulator?.stop();
    _locationSimulator?.listener = null;
    _locationSimulator = null;
    _isRerouting = false;
    _isCameraTracking = false;
    final reportingService = _ref.read(driverLocationReportingServiceProvider);
    reportingService.setSimulatedLocation(null);
    reportingService.updateNavigationProgress(
      remainingDistanceMeters: null,
      traveledDistanceMeters: null,
      remainingDurationSeconds: null,
    );
    reportingService.stopPeriodicReporting();
    if (_mapLocationSub == null) {
      _ref.read(driverHereLocationServiceProvider).stop();
    }
    _visualNavigator?.route = null;
    _visualNavigator?.stopRendering();
    _nextManeuverAction = null;
    _distanceToNextManeuverMeters = null;
    _nextRoadName = null;
    _lanesForNextManeuver = null;
    _safetyCameraWarning = null;
    _activeTruckRestrictions.clear();
    _currentSpeedKmh = null;
    _currentSpeedLimitKmh = null;
    _isSpeedExceeded = false;
    notifyListeners();
  }

  void _onRouteDeviation(RouteDeviation deviation) {
    if (_isRerouting) return;
    if (_lastDispatcherStops.isEmpty) return;
    final routingEngine = _routingEngine;
    if (routingEngine == null) return;

    _isRerouting = true;
    notifyListeners();

    final startCoords =
        deviation.currentLocation.mapMatchedLocation?.coordinates ??
        deviation.currentLocation.originalLocation.coordinates;

    final waypoints = <Waypoint>[
      Waypoint.withDefaults(startCoords),
      ..._lastDispatcherStops.map(Waypoint.withDefaults),
    ];

    void onResult(RoutingError? error, List<Route>? routes) {
      _isRerouting = false;
      if (error != null || routes == null || routes.isEmpty) {
        notifyListeners();
        return;
      }
      final route = routes.first;
      _currentRoute = route;
      _visualNavigator?.route = route;
      notifyListeners();
    }

    final routePlan = _lastDispatcherRoutePlan;
    if (routePlan != null &&
        routePlan.routingProfile.transportMode.toLowerCase() == 'car') {
      routingEngine.calculateCarRoute(
        waypoints,
        _buildCarOptions(routePlan.routingProfile),
        onResult,
      );
    } else if (routePlan != null) {
      routingEngine.calculateTruckRoute(
        waypoints,
        _buildTruckOptions(routePlan.routingProfile, routePlan.vehicleSpec),
        onResult,
      );
    } else {
      routingEngine.calculateTruckRoute(
        waypoints,
        TruckOptions()
          ..routeOptions.enableTolls = true
          ..routeOptions.enableRouteHandle = true
          ..routeOptions.trafficOptimizationMode =
              TrafficOptimizationMode.timeDependent,
        onResult,
      );
    }
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

          final totalMeters = _currentRoute?.lengthInMeters;
          _ref.read(driverLocationReportingServiceProvider).updateNavigationProgress(
            remainingDistanceMeters: _remainingDistanceInMeters,
            traveledDistanceMeters: (totalMeters != null && _remainingDistanceInMeters != null)
                ? totalMeters - _remainingDistanceInMeters!
                : null,
            remainingDurationSeconds: _remainingDuration?.inSeconds,
          );
        }

        final maneuverProgress = progress.maneuverProgress.isNotEmpty
            ? progress.maneuverProgress.first
            : null;
        if (maneuverProgress != null) {
          final maneuver = visualNavigator.getManeuver(
            maneuverProgress.maneuverIndex,
          );
          _nextManeuverAction = maneuver?.action;
          _distanceToNextManeuverMeters = maneuverProgress.remainingDistanceInMeters;
          _nextRoadName = maneuver?.nextRoadTexts.names.getDefaultValue();
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

      _routeDeviationListener = RouteDeviationListener((deviation) {
        _onRouteDeviation(deviation);
      });

      _milestoneStatusListener = MilestoneStatusListener((milestone, status) {
        if (status == MilestoneStatus.reached) {
          _milestonesReached++;
          notifyListeners();
        }
      });

      _speedLimitListener = SpeedLimitListener((speedLimit) {
        final limitMs = speedLimit.effectiveSpeedLimitInMetersPerSecond();
        _currentSpeedLimitKmh = limitMs != null ? limitMs * 3.6 : null;
        notifyListeners();
      });

      _speedWarningListener = SpeedWarningListener((status) {
        _isSpeedExceeded = status == SpeedWarningStatus.speedLimitExceeded;
        notifyListeners();
      });

      _maneuverViewLaneAssistanceListener =
          ManeuverViewLaneAssistanceListener((assistance) {
        _lanesForNextManeuver = assistance.lanesForNextManeuver.isEmpty
            ? null
            : List.unmodifiable(assistance.lanesForNextManeuver);
        notifyListeners();
      });

      visualNavigator.routeProgressListener = _routeProgressListener;
      visualNavigator.eventTextListener = _eventTextListener;
      visualNavigator.destinationReachedListener = _destinationReachedListener;
      visualNavigator.routeDeviationListener = _routeDeviationListener;
      visualNavigator.milestoneStatusListener = _milestoneStatusListener;
      visualNavigator.speedLimitListener = _speedLimitListener;
      visualNavigator.speedWarningListener = _speedWarningListener;
      visualNavigator.maneuverViewLaneAssistanceListener =
          _maneuverViewLaneAssistanceListener;

      _safetyCameraWarningListener = SafetyCameraWarningListener((warning) {
        if (warning.distanceType == DistanceType.passed ||
            warning.distanceType == DistanceType.reached) {
          _safetyCameraWarning = null;
        } else {
          _safetyCameraWarning = warning;
        }
        notifyListeners();
      });

      visualNavigator.safetyCameraWarningListener =
          _safetyCameraWarningListener;

      _truckRestrictionsWarningListener =
          TruckRestrictionsWarningListener((warnings) {
        for (final w in warnings) {
          _activeTruckRestrictions.removeWhere(
            (e) =>
                e.weightRestriction == w.weightRestriction &&
                e.dimensionRestriction == w.dimensionRestriction &&
                e.truckRoadType == w.truckRoadType &&
                e.hazardousMaterials.length == w.hazardousMaterials.length &&
                e.hazardousMaterials
                    .toSet()
                    .containsAll(w.hazardousMaterials),
          );
          if (w.distanceType == DistanceType.ahead) {
            _activeTruckRestrictions.add(w);
          }
        }
        notifyListeners();
      });
      visualNavigator.truckRestrictionsWarningListener =
          _truckRestrictionsWarningListener;
      visualNavigator.truckRestrictionsWarningOptions =
          TruckRestrictionsWarningOptions()
            ..filterOutInactiveTimeDependentRestrictions = true;

      _visualNavigator = visualNavigator;
      return visualNavigator;
    } on InstantiationException {
      throw StateError('VisualNavigator init failed.');
    }
  }

  void _handleHereLocationUpdate(
    Location location, {
    bool centerCamera = false,
  }) {
    final coords = location.coordinates;
    _lastUserCoordinates = coords;

    if (isFollowing) {
      _currentSpeedKmh = (location.speedInMetersPerSecond ?? 0.0) * 3.6;
    }

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
    if (isFollowing) {
      _resumeNavigationCameraTracking();
      return;
    }
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

  void _resumeNavigationCameraTracking() {
    _cancelNavigationCameraAutoResume();

    final visualNavigator = _visualNavigator;
    if (visualNavigator == null) return;

    visualNavigator.cameraBehavior = _buildNavigationCameraBehavior();
    _isCameraTracking = true;

    final currentLocation = _ref
        .read(driverHereLocationServiceProvider)
        .lastKnownHereLocation;
    if (currentLocation != null) {
      _handleHereLocationUpdate(currentLocation);
    }

    notifyListeners();
  }

  void _pauseNavigationCameraTracking() {
    _cancelNavigationCameraAutoResume();
    _visualNavigator?.cameraBehavior = null;
    _isCameraTracking = false;
    notifyListeners();
  }

  void _scheduleNavigationCameraAutoResume() {
    _cancelNavigationCameraAutoResume();
    if (!isFollowing) return;

    _navigationCameraResumeTimer = Timer(
      _navigationCameraAutoResumeDelay,
      () {
        _navigationCameraResumeTimer = null;
        if (!isFollowing) return;
        _resumeNavigationCameraTracking();
      },
    );
  }

  void _cancelNavigationCameraAutoResume() {
    _navigationCameraResumeTimer?.cancel();
    _navigationCameraResumeTimer = null;
  }

  Future<void> _showCurrentLocationOnMap({required bool centerCamera}) async {
    if (_map == null) return;

    try {
      final coords = await _getMapIndicatorCoordinates();
      final map = _map;
      if (map == null) return;

      _lastUserCoordinates = coords;
      _ensureLocationIndicatorEnabled();
      _updateHereLocationIndicator(coords);

      if (centerCamera && !isFollowing) {
        final measure = MapMeasure(MapMeasureKind.distanceInMeters, 1200);
        map.camera.lookAtPointWithMeasure(coords, measure);
      }

      notifyListeners();
    } catch (_) {
      // The stream listener will update the marker when HERE emits a fix.
    }
  }

  Future<void> _showCurrentLocationFromLastKnown() async {
    final map = _map;
    if (map == null || isFollowing) return;

    try {
      final coords = await _getMapIndicatorCoordinates();
      if (_map != map || isFollowing) return;

      _lastUserCoordinates = coords;
      _ensureLocationIndicatorEnabled();
      _updateHereLocationIndicator(coords);
      notifyListeners();
    } catch (_) {
      // The stream listener will update the marker when HERE emits a fix.
    }
  }

  Future<GeoCoordinates> _getUserCoordinates() async {
    final locationService = _ref.read(driverHereLocationServiceProvider);
    final lastKnown = locationService.lastKnownHereLocation;
    if (lastKnown != null) return lastKnown.coordinates;

    final location = await locationService.getCurrentHereLocation(
      maxAge: const Duration(minutes: 5),
      timeout: const Duration(seconds: 30),
    );
    return location.coordinates;
  }

  Future<void> _showUserLocationIndicatorWithoutCentering() async {
    final previewToken = _dispatcherPreviewFitToken;
    if (_map == null) return;

    _ensureMapLocationUpdates();

    try {
      final coords = await _getMapIndicatorCoordinates();
      if (_map == null) return;
      if (_lastDispatcherRoutePlan == null) return;
      if (previewToken != _dispatcherPreviewFitToken) return;

      _lastUserCoordinates = coords;
      _ensureLocationIndicatorEnabled();
      _updateHereLocationIndicator(coords);
    } catch (_) {
      // The stream listener will update the marker when HERE emits a fix.
    }
  }

  Future<GeoCoordinates> _getMapIndicatorCoordinates() async {
    final locationService = _ref.read(driverHereLocationServiceProvider);
    final lastKnown = locationService.lastKnownHereLocation;
    if (lastKnown != null) return lastKnown.coordinates;

    final location = await locationService.getCurrentHereLocation(
      maxAge: const Duration(days: 365),
      timeout: const Duration(seconds: 1),
    );
    return location.coordinates;
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

  void _updateHereLocationIndicator(GeoCoordinates coords, {double? bearing}) {
    final map = _map;
    if (map == null) return;

    final double finalBearing;
    if (bearing != null) {
      finalBearing = bearing;
    } else {
      final prev = _prevCoordsForBearing;
      finalBearing = prev != null ? _bearingDegrees(from: prev, to: coords) : 0.0;
    }
    _prevCoordsForBearing = coords;

    final location = Location.withCoordinates(coords)
      ..time = DateTime.now()
      ..bearingInDegrees = finalBearing;

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
    _cancelNavigationCameraAutoResume();
    _positionSub?.cancel();
    _positionSub = null;
    _locationSimulator?.stop();
    _locationSimulator?.listener = null;
    _locationSimulator = null;
    _mapLocationSub?.cancel();
    _mapLocationSub = null;
    _isRerouting = false;
    _ref.read(driverLocationReportingServiceProvider).stopPeriodicReporting();
    _ref.read(driverHereLocationServiceProvider).stop();
    _visualNavigator?.stopRendering();
    _visualNavigator?.route = null;
    _visualNavigator = null;
    _routeDeviationListener = null;
    _milestoneStatusListener = null;
    _speedLimitListener = null;
    _speedWarningListener = null;
    _maneuverViewLaneAssistanceListener = null;
    _safetyCameraWarningListener = null;
    _truckRestrictionsWarningListener = null;

    _locationIndicator?.disable();
    _locationIndicator = null;

    super.dispose();
  }
}
