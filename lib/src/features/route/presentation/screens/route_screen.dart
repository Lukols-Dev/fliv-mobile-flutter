import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:here_sdk/core.dart';

import 'package:mobile/src/core/here/driver_here_location_service.dart';
import 'package:mobile/src/core/l10n/app_localizations.dart';
import 'package:mobile/src/core/location/location_permission_channel.dart';
import 'package:mobile/src/features/orders/application/current_driver_order_provider.dart';
import 'package:mobile/src/features/orders/application/driver_order_details_provider.dart';
import 'package:mobile/src/features/orders/application/update_order_status_controller.dart';
import 'package:mobile/src/features/orders/domain/driver_transport_order_details.dart';
import 'package:mobile/src/features/route/data/driver_location_reporting_service.dart';
import 'package:mobile/src/features/route/presentation/controllers/route_map_controller.dart';
import 'package:mobile/src/features/route/presentation/widgets/route_controls_panel.dart';
import 'package:mobile/src/features/route/presentation/widgets/route_incident_bottom_sheet.dart';
import 'package:mobile/src/features/route/presentation/widgets/route_map_layer.dart';
import 'package:mobile/src/features/route/presentation/widgets/order_status_bottom_sheet.dart';
import 'package:mobile/src/features/orders/presentation/widgets/route_stops_progress_list.dart';
import 'package:mobile/src/features/route/data/route_point_arrival_api.dart';
import 'package:mobile/src/features/route/presentation/widgets/route_arrival_bottom_sheet.dart';

final routeMapControllerProvider = ChangeNotifierProvider<RouteMapController>((
  ref,
) {
  final c = RouteMapController(ref);
  ref.onDispose(c.dispose);
  return c;
});

typedef RouteMapLayerBuilder =
    Widget Function({
      required RouteMapController controller,
      required VoidCallback onBack,
      required double bottomPaddingForFab,
      VoidCallback? onReportEvent,
    });

final routeMapLayerBuilderProvider = Provider<RouteMapLayerBuilder>((ref) {
  return ({
    required RouteMapController controller,
    required VoidCallback onBack,
    required double bottomPaddingForFab,
    VoidCallback? onReportEvent,
  }) {
    return RouteMapLayer(
      controller: controller,
      bottomPaddingForFab: bottomPaddingForFab,
      onBack: onBack,
      onReportEvent: onReportEvent,
    );
  };
});

class RouteScreen extends ConsumerStatefulWidget {
  const RouteScreen({super.key});

  @override
  ConsumerState<RouteScreen> createState() => _RouteScreenState();
}

enum _RouteLocationAccessState {
  checking,
  granted,
  denied,
  deniedForever,
  serviceDisabled,
  unavailable,
}

class _RouteScreenState extends ConsumerState<RouteScreen> {
  static const _sheetMin = 0.15;
  static const _sheetMax = 0.70;

  String? _locationPreparationMessage;
  _RouteLocationAccessState _locationAccessState =
      _RouteLocationAccessState.checking;
  RouteMapController? _routeMapController;
  late final DriverLocationReportingService _locationReportingService;
  late final DraggableScrollableController _sheetController;
  late double _sheetInitialSize;
  bool _isPreparingLocationAccess = false;
  bool _isStartingNavigation = false;
  bool _isFetchingRoute = false;
  bool _routeReady = false;
  String? _currentOrderId;

  String _formatKm(int meters) => (meters / 1000).toStringAsFixed(1);
  String _formatMin(AppLocalizations t, Duration d) {
    final h = d.inHours;
    final min = (d.inSeconds % 3600) ~/ 60;
    if (h > 0) return '${h}h $min ${t.common_minutes_short}';
    return '$min ${t.common_minutes_short}';
  }

  bool _isValidRoutePoint(DriverTransportOrderRoutePoint point) {
    return point.latitude >= -90 &&
        point.latitude <= 90 &&
        point.longitude >= -180 &&
        point.longitude <= 180;
  }

  @override
  void initState() {
    super.initState();
    _locationReportingService = ref.read(
      driverLocationReportingServiceProvider,
    );
    _sheetController = DraggableScrollableController();
    _sheetInitialSize = ref.read(routeMapControllerProvider).isFollowing
        ? _sheetMin
        : _sheetMax;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _prepareHereLocationOnMapOpen();
    });
  }

  @override
  void dispose() {
    if (!(_routeMapController?.isFollowing ?? false)) {
      _locationReportingService.stopPeriodicReporting();
    }
    _routeMapController?.detachMap();
    _sheetController.dispose();
    super.dispose();
  }

  Future<void> _collapseRouteSheet() async {
    try {
      if (!_sheetController.isAttached) return;

      await _sheetController.animateTo(
        _sheetMin,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    } catch (_) {
      // Collapsing the sheet is cosmetic and should not block navigation.
    }
  }

  Future<void> _openChangeStatusSheet({required String orderId}) async {
    final t = AppLocalizations.of(context)!;
    final selected = await showOrderStatusBottomSheet(context);

    if (!mounted) return;
    if (selected == null) return;

    final controller = ref.read(updateOrderStatusControllerProvider.notifier);

    try {
      await controller.updateStatus(orderId: orderId, status: selected.apiKey);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${t.route_status_changed_prefix} ${selected.title(t)}',
          ),
          backgroundColor: const Color(0xFF0F4D46),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${t.route_status_change_failed}: ${e.toString()}'),
          backgroundColor: const Color(0xFFEF4444),
        ),
      );
    }
  }

  Future<void> _openReportEventSheet({required String orderId}) async {
    await showReportEventBottomSheet(context, orderId: orderId);
  }

  bool get _isLocationAccessGranted =>
      _locationAccessState == _RouteLocationAccessState.granted;

  Future<void> _prepareHereLocationOnMapOpen() async {
    if (_isPreparingLocationAccess) return;
    _isPreparingLocationAccess = true;

    if (mounted) {
      setState(() {
        _locationAccessState = _RouteLocationAccessState.checking;
        _locationPreparationMessage = null;
      });
    }

    try {
      await ref.read(driverHereLocationServiceProvider).prepare();
      if (!mounted) return;
      setState(() {
        _locationAccessState = _RouteLocationAccessState.granted;
        _locationPreparationMessage = null;
      });
      final controller = ref.read(routeMapControllerProvider);
      if (!controller.isFollowing) {
        controller.showCurrentLocationWhenReady(centerCamera: true);
      }
    } on DriverHereLocationPermissionException catch (e) {
      if (!mounted) return;
      setState(() => _locationAccessState = _stateFromPermissionError(e));
      _showSnack(e.message);
    } on DriverHereLocationUnavailableException {
      if (!mounted) return;
      setState(() {
        _locationAccessState = _RouteLocationAccessState.unavailable;
        _locationPreparationMessage = driverLocationUnavailableMessage;
      });
      _showSnack(driverLocationUnavailableMessage);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _locationAccessState = _RouteLocationAccessState.unavailable;
        _locationPreparationMessage = driverLocationUnavailableMessage;
      });
      _showSnack(driverLocationUnavailableMessage);
      // ignore: avoid_print
      print('HERE location prepare error: $e');
    } finally {
      _isPreparingLocationAccess = false;
    }
  }

  _RouteLocationAccessState _stateFromPermissionError(
    DriverHereLocationPermissionException e,
  ) {
    return switch (e.status) {
      AppLocationPermissionStatus.deniedForever =>
        _RouteLocationAccessState.deniedForever,
      AppLocationPermissionStatus.serviceDisabled =>
        _RouteLocationAccessState.serviceDisabled,
      _ => _RouteLocationAccessState.denied,
    };
  }

  String _locationAccessMessage() {
    return switch (_locationAccessState) {
      _RouteLocationAccessState.serviceDisabled =>
        driverLocationServiceDisabledMessage,
      _RouteLocationAccessState.deniedForever =>
        driverLocationPermissionDeniedForeverMessage,
      _RouteLocationAccessState.denied => driverLocationPermissionMessage,
      _RouteLocationAccessState.unavailable =>
        _locationPreparationMessage ?? driverLocationUnavailableMessage,
      _ => driverLocationPermissionMessage,
    };
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _startNavigationAndReportLocation({
    required String orderId,
  }) async {
    if (_isStartingNavigation) return;

    setState(() => _isStartingNavigation = true);
    final messenger = ScaffoldMessenger.of(context);

    try {
      await ref.read(routeMapControllerProvider).startFollowing();
      if (!mounted) return;
      setState(() => _locationPreparationMessage = null);
      await _collapseRouteSheet();
    } on DriverHereLocationPermissionException catch (e) {
      if (!mounted) return;
      setState(() => _locationPreparationMessage = e.message);
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      return;
    } on DriverHereLocationUnavailableException {
      if (!mounted) return;
      setState(
        () => _locationPreparationMessage = driverLocationUnavailableMessage,
      );
      messenger.showSnackBar(
        const SnackBar(content: Text(driverLocationUnavailableMessage)),
      );
      return;
    } catch (e) {
      if (!mounted) return;
      setState(
        () => _locationPreparationMessage = driverLocationUnavailableMessage,
      );
      final t = AppLocalizations.of(context)!;
      messenger.showSnackBar(
        SnackBar(content: Text('${t.common_location}: $e')),
      );
      return;
    } finally {
      if (mounted) setState(() => _isStartingNavigation = false);
    }

    try {
      await _locationReportingService.startPeriodicReporting(
        transportOrderId: orderId,
      );
    } on DriverHereLocationUnavailableException {
      if (!mounted) return;
      setState(
        () => _locationPreparationMessage = driverLocationUnavailableMessage,
      );
      messenger.showSnackBar(
        const SnackBar(content: Text(driverLocationUnavailableMessage)),
      );
    } on DriverLocationReportingException catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text(driverLocationReportFailedMessage)),
      );
    }
  }

  Future<void> _fetchRoute({required String orderId}) async {
    if (_isFetchingRoute) return;
    setState(() => _isFetchingRoute = true);
    final messenger = ScaffoldMessenger.of(context);
    final t = AppLocalizations.of(context)!;
    try {
      ref.invalidate(driverOrderDetailsProvider(orderId));
      final details = await ref.read(driverOrderDetailsProvider(orderId).future);
      if (!mounted) return;

      final routePlan = details.routePlan;
      if (routePlan == null || routePlan.polyline.trim().isEmpty) {
        messenger.showSnackBar(SnackBar(content: Text(t.route_no_configured_route)));
        return;
      }
      final routePoints = details.routePoints
          .where(_isValidRoutePoint)
          .toList(growable: false);
      if (routePoints.isEmpty) {
        messenger.showSnackBar(SnackBar(content: Text(t.route_no_configured_route)));
        return;
      }

      final controller = ref.read(routeMapControllerProvider);
      final firstStop = routePoints.first;
      await controller.calculateApproachRouteToFirstStop(
        firstStop: GeoCoordinates(firstStop.latitude, firstStop.longitude),
        routePlan: routePlan,
        routePoints: routePoints,
      );
      if (!mounted) return;

      final approachRoute = controller.currentRoute;
      if (approachRoute != null) {
        try {
          await _locationReportingService.reportApproachRoute(
            transportOrderId: orderId,
            distanceMeters: approachRoute.lengthInMeters,
            duration: approachRoute.duration,
          );
        } catch (_) {}
      }

      if (!mounted) return;
      setState(() => _routeReady = true);
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isFetchingRoute = false);
    }
  }

  Future<void> _handleArrivalFlow({
    required String orderId,
    required DriverTransportOrderRoutePoint point,
    required RouteMapController controller,
  }) async {
    if (!mounted) return;

    await showArrivalConfirmationBottomSheet(
      context,
      point: point,
      indexOneBased: controller.confirmedStops + 1,
      total: controller.totalStops,
    );

    if (!mounted) return;

    final location =
        ref.read(driverHereLocationServiceProvider).lastKnownHereLocation;
    try {
      await ref.read(routePointArrivalApiProvider).confirmArrival(
        orderId: orderId,
        routePointId: point.id,
        sequence: point.sequence,
        confirmedAt: DateTime.now(),
        latitude: location?.coordinates.latitude ?? point.latitude,
        longitude: location?.coordinates.longitude ?? point.longitude,
      );
      ref.invalidate(driverOrderDetailsProvider(orderId));
    } catch (_) {
      if (mounted) {
        final t = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.route_arrival_confirmation_failed),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }

    if (!mounted) return;
    if (controller.isLastPoint) return;
    await controller.advanceToNextLeg();
  }

  Widget _buildLocationAccessScaffold(AppLocalizations t) {
    final isChecking =
        _locationAccessState == _RouteLocationAccessState.checking;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 2,
                  child: IconButton(
                    tooltip: t.common_back,
                    onPressed: () => context.go('/home'),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 58,
                      width: 58,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE7EFE7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.my_location_rounded,
                        color: Color(0xFF0F4D46),
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      t.common_location,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Figtree',
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _locationAccessMessage(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Figtree',
                        color: Color(0xFF6B7280),
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 22),
                    if (isChecking)
                      const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Color(0xFF0F4D46),
                          strokeWidth: 2.5,
                        ),
                      )
                    else
                      FilledButton.icon(
                        onPressed: _prepareHereLocationOnMapOpen,
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(t.home_refresh_location_tooltip),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF0F4D46),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final controller = ref.watch(routeMapControllerProvider);
    _routeMapController = controller;

    ref.listen<RouteMapController>(routeMapControllerProvider, (_, next) {
      final arrivalPoint = next.pendingArrivalPoint;
      if (arrivalPoint != null) {
        next.consumeArrivalPoint();
        final orderId = _currentOrderId;
        if (orderId != null && mounted) {
          _handleArrivalFlow(
            orderId: orderId,
            point: arrivalPoint,
            controller: next,
          ).ignore();
        }
        return;
      }

      if (!next.pendingAutoStart) return;
      next.consumeAutoStart();
      final orderId = _currentOrderId;
      if (orderId == null || _isStartingNavigation) return;
      _startNavigationAndReportLocation(orderId: orderId).then((_) {
        if (!mounted || !next.isFollowing) return;
        ref
            .read(updateOrderStatusControllerProvider.notifier)
            .updateStatus(orderId: orderId, status: 'IN_PROGRESS')
            .ignore();
      });
    });

    if (!_isLocationAccessGranted) {
      return _buildLocationAccessScaffold(t);
    }

    final currentOrderAsync = ref.watch(currentDriverOrderProvider);
    final currentOrder = currentOrderAsync.asData?.value;
    final buildRouteMapLayer = ref.watch(routeMapLayerBuilderProvider);
    final hasOrder = currentOrder != null;
    final orderDetailsAsync = hasOrder
        ? ref.watch(driverOrderDetailsProvider(currentOrder.id))
        : null;
    final orderDetails = orderDetailsAsync?.asData?.value;
    final routePoints =
        orderDetails?.routePoints ?? const <DriverTransportOrderRoutePoint>[];
    final validRoutePoints = routePoints
        .where(_isValidRoutePoint)
        .toList(growable: false);
    final routePlan = orderDetails?.routePlan;
    final savedRoutePlan =
        routePlan != null && routePlan.polyline.trim().isNotEmpty
        ? routePlan
        : null;
    // Reset route state when order changes (but not during active navigation)
    final incomingOrderId = currentOrder?.id;
    if (incomingOrderId != _currentOrderId) {
      _currentOrderId = incomingOrderId;
      _routeReady = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final c = ref.read(routeMapControllerProvider);
        if (!c.isFollowing) {
          c.clearDispatcherRoutePreview();
        }
      });
    }

    final screenH = MediaQuery.of(context).size.height;
    final bottomSafe = MediaQuery.of(context).padding.bottom;
    final bottomPaddingForFab = (screenH * _sheetMin) + 12 - bottomSafe;

    final route = controller.currentRoute;
    final showRouteControls = controller.isFollowing && hasOrder;
    final showChangeStatus = controller.isFollowing && hasOrder;
    final approachDistanceM = route?.lengthInMeters ?? 0;
    final approachDuration = route?.duration ?? Duration.zero;
    final dispatcherDuration = Duration(seconds: savedRoutePlan?.durationSeconds ?? 0);
    final totalDistanceM = approachDistanceM + (savedRoutePlan?.distanceMeters ?? 0);
    final totalDuration = approachDuration + dispatcherDuration;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          buildRouteMapLayer(
            controller: controller,
            onBack: () => context.go('/home'),
            bottomPaddingForFab:
                (!hasOrder && !controller.isFollowing) ? 0 : bottomPaddingForFab,
            onReportEvent: hasOrder
                ? () => _openReportEventSheet(orderId: currentOrder.id)
                : null,
          ),

          if (!hasOrder && !controller.isFollowing)
            const _NoOrderMapOverlay()
          else if (hasOrder && !_routeReady && !controller.isFollowing)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                  boxShadow: [
                    BoxShadow(color: Color(0x22000000), blurRadius: 18, offset: Offset(0, -6)),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 44,
                            height: 5,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5E7EB),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          t.route_navigation_title,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Figtree',
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${t.route_order_number_prefix}${currentOrder.ztNumber}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Figtree',
                            color: Color(0xFF111827),
                          ),
                        ),
                        if (_locationPreparationMessage != null) ...[
                          const SizedBox(height: 8),
                          _LocationNotice(message: _locationPreparationMessage!),
                        ],
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 54,
                          child: FilledButton(
                            onPressed: _isFetchingRoute
                                ? null
                                : () => _fetchRoute(orderId: currentOrder.id),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF0F4D46),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 2,
                            ),
                            child: _isFetchingRoute
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.route_rounded, size: 24),
                                      const SizedBox(width: 10),
                                      Text(
                                        t.route_fetch_route,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Figtree',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          else
          Align(
            alignment: Alignment.bottomCenter,
            child: DraggableScrollableSheet(
              controller: _sheetController,
              expand: false,
              snap: true,
              snapSizes: const [_sheetMin, _sheetMax],
              minChildSize: _sheetMin,
              initialChildSize: _sheetInitialSize,
              maxChildSize: _sheetMax,
              builder: (context, scrollController) {
                return Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(22),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x22000000),
                          blurRadius: 18,
                          offset: Offset(0, -6),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (controller.isFollowing && hasOrder) ...[
                            // Pasek postępu nawigacji
                            const SizedBox(height: 14),
                            _NavigationProgressPanel(
                              remainingDistanceInMeters:
                                  controller.remainingDistanceInMeters,
                              remainingDuration: controller.remainingDuration,
                              totalDistanceInMeters:
                                  controller.currentRoute?.lengthInMeters,
                              nextPointAddress: controller.nextPointAddress,
                            ),
                          ] else if (hasOrder) ...[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 44,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE5E7EB),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    t.route_navigation_title,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      fontFamily: 'Figtree',
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${t.route_order_number_prefix}${currentOrder.ztNumber}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Figtree',
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                  if (_locationPreparationMessage != null) ...[
                                    const SizedBox(height: 8),
                                    _LocationNotice(message: _locationPreparationMessage!),
                                  ],
                                  const SizedBox(height: 16),
                                  ...[
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _InfoChip(
                                            label: t.route_total_distance_label,
                                            value: '${_formatKm(totalDistanceM)} km',
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: _InfoChip(
                                            label: t.route_time_label,
                                            value: _formatMin(t, totalDuration),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    RouteStopsProgressList(
                                      routePoints: validRoutePoints,
                                      confirmedStops: controller.confirmedStops,
                                      myLocationLabel: t.route_my_location,
                                      approachDistanceM: approachDistanceM,
                                    ),
                                    const SizedBox(height: 16),
                                    if (controller.navigationError != null) ...[
                                      Text(
                                        controller.navigationError!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Figtree',
                                          color: Color(0xFFEF4444),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                    ],
                                    SizedBox(
                                      height: 54,
                                      child: FilledButton(
                                        onPressed: _isStartingNavigation
                                            ? null
                                            : () async {
                                                try {
                                                  await _startNavigationAndReportLocation(
                                                    orderId: currentOrder.id,
                                                  );
                                                } catch (_) {
                                                  return;
                                                }
                                                if (!mounted || !controller.isFollowing) return;
                                                try {
                                                  await ref
                                                      .read(updateOrderStatusControllerProvider.notifier)
                                                      .updateStatus(
                                                        orderId: currentOrder.id,
                                                        status: 'IN_PROGRESS',
                                                      );
                                                } catch (e) {
                                                  if (!mounted) return;
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        '${t.route_status_change_failed}: ${e.toString()}',
                                                      ),
                                                      backgroundColor: const Color(0xFFEF4444),
                                                    ),
                                                  );
                                                }
                                              },
                                        style: FilledButton.styleFrom(
                                          backgroundColor: const Color(0xFF0F4D46),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                          elevation: 2,
                                        ),
                                        child: _isStartingNavigation
                                            ? const SizedBox(
                                                height: 22,
                                                width: 22,
                                                child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2.5,
                                                ),
                                              )
                                            : Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Icon(Icons.play_arrow_rounded, size: 24),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    t.route_start_route,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'Figtree',
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ], // end else (non-navigation layout)
                          // Route controls
                          if (showRouteControls) ...[
                            const SizedBox(height: 18),
                            RouteControlsPanel(
                              isFollowing: controller.isFollowing,
                              onReportEvent: () => _openReportEventSheet(
                                orderId: currentOrder.id,
                              ),
                              onPause: controller.stopFollowing,
                              onResume: () async {
                                try {
                                  await controller.startFollowing();
                                  if (!mounted) return;
                                  await _collapseRouteSheet();
                                } catch (e) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${t.common_location}: $e'),
                                    ),
                                  );
                                }
                              },
                              onFinishRoute: controller.stopFollowing,
                            ),
                          ],

                          // Change status button
                          if (showChangeStatus) ...[
                            Container(
                              padding: const EdgeInsets.fromLTRB(
                                18,
                                18,
                                18,
                                60,
                              ),
                              child: SizedBox(
                                height: 54,
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: () => _openChangeStatusSheet(
                                    orderId: currentOrder.id,
                                  ),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: const Color(0xFFF2542F),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    t.route_change_status,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Figtree',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationNotice extends StatelessWidget {
  const _LocationNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFED7AA)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.location_off_rounded,
            size: 18,
            color: Color(0xFFC2410C),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: 'Figtree',
                color: Color(0xFF9A3412),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              fontFamily: 'Figtree',
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: 'Figtree',
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationProgressPanel extends StatelessWidget {
  const _NavigationProgressPanel({
    required this.remainingDistanceInMeters,
    required this.remainingDuration,
    required this.totalDistanceInMeters,
    this.nextPointAddress,
  });

  final int? remainingDistanceInMeters;
  final Duration? remainingDuration;
  final int? totalDistanceInMeters;
  final String? nextPointAddress;

  String _formatDistance(int? meters) {
    if (meters == null) return '--';
    if (meters < 1000) return '$meters m';
    return '${(meters / 1000).round()} km';
  }

  String _formatDuration(Duration? d) {
    if (d == null) return '--';
    final h = d.inHours;
    final min = (d.inSeconds % 3600) ~/ 60;
    if (h > 0) return '~ ${h}h ${min}min';
    return '~ $min min';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final double progress;
    if (totalDistanceInMeters != null &&
        totalDistanceInMeters! > 0 &&
        remainingDistanceInMeters != null) {
      final traveled = totalDistanceInMeters! - remainingDistanceInMeters!;
      progress = (traveled / totalDistanceInMeters!).clamp(0.0, 1.0);
    } else {
      progress = 0.0;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      t.route_next_point,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Figtree',
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      nextPointAddress ?? '--',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Figtree',
                        color: Color(0xFF111827),
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatDistance(remainingDistanceInMeters),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Figtree',
                      color: Color(0xFF0F4D46),
                      height: 1.1,
                    ),
                  ),
                  Text(
                    _formatDuration(remainingDuration),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Figtree',
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: SliderComponentShape.noOverlay,
              activeTrackColor: const Color(0xFF0F4D46),
              inactiveTrackColor: const Color(0xFFE5E7EB),
              thumbColor: const Color(0xFF0F4D46),
            ),
            child: Slider(value: progress, onChanged: null),
          ),
        ],
      ),
    );
  }
}

class _NoOrderMapOverlay extends StatelessWidget {
  const _NoOrderMapOverlay();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F1E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.route_rounded,
                  color: Color(0xFF6B7280),
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                t.route_no_order_map_title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Figtree',
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                t.route_no_order_map_description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Figtree',
                  color: Color(0xFF6B7280),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
