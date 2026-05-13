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
      ValueNotifier<double>? sheetHeightNotifier,
    });

final routeMapLayerBuilderProvider = Provider<RouteMapLayerBuilder>((ref) {
  return ({
    required RouteMapController controller,
    required VoidCallback onBack,
    required double bottomPaddingForFab,
    ValueNotifier<double>? sheetHeightNotifier,
  }) {
    return RouteMapLayer(
      controller: controller,
      bottomPaddingForFab: bottomPaddingForFab,
      sheetHeightNotifier: sheetHeightNotifier,
      onBack: onBack,
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
  static const _sheetMin = 0.20;
  static const _sheetInitial = 0.30;
  static const _sheetMax = 0.70;

  String? _lastDispatcherPreviewKey;
  String? _locationPreparationMessage;
  _RouteLocationAccessState _locationAccessState =
      _RouteLocationAccessState.checking;
  RouteMapController? _routeMapController;
  late final DriverLocationReportingService _locationReportingService;
  bool _isPreparingLocationAccess = false;
  bool _isStartingNavigation = false;

  String _formatKm(int meters) => (meters / 1000).toStringAsFixed(1);
  String _formatMin(AppLocalizations t, Duration d) =>
      '${(d.inSeconds / 60).round()} ${t.common_minutes_short}';

  bool _isValidRoutePoint(DriverTransportOrderRoutePoint point) {
    return point.latitude >= -90 &&
        point.latitude <= 90 &&
        point.longitude >= -180 &&
        point.longitude <= 180;
  }

  @override
  void initState() {
    super.initState();
    _locationReportingService = ref.read(driverLocationReportingServiceProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _prepareHereLocationOnMapOpen();
    });
  }

  @override
  void dispose() {
    _locationReportingService.stopPeriodicReporting();
    _routeMapController?.detachMap();
    super.dispose();
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
      ref
          .read(routeMapControllerProvider)
          .showCurrentLocationWhenReady(centerCamera: true);
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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

  String _dispatcherPreviewKey({
    required String orderId,
    required DriverTransportOrderRoutePlan routePlan,
  }) {
    final hash = routePlan.calculationHash;
    if (hash != null && hash.trim().isNotEmpty) {
      return '$orderId:$hash';
    }

    return '$orderId:${routePlan.polyline.hashCode}';
  }

  void _syncDispatcherRoutePreview({
    required String? orderId,
    required DriverTransportOrderRoutePlan? routePlan,
    required List<DriverTransportOrderRoutePoint> routePoints,
  }) {
    if (orderId != null &&
        routePlan != null &&
        routePlan.polyline.trim().isNotEmpty) {
      final previewRoutePlan = routePlan;
      final previewKey = _dispatcherPreviewKey(
        orderId: orderId,
        routePlan: previewRoutePlan,
      );

      if (_lastDispatcherPreviewKey == previewKey) return;
      _lastDispatcherPreviewKey = previewKey;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref
            .read(routeMapControllerProvider)
            .showDispatcherRoutePreview(
              routePlan: previewRoutePlan,
              routePoints: routePoints,
            );
      });
      return;
    }

    if (_lastDispatcherPreviewKey == null) return;
    _lastDispatcherPreviewKey = null;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(routeMapControllerProvider).clearDispatcherRoutePreview();
    });
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
    final hasConfiguredRoute = validRoutePoints.isNotEmpty;

    _syncDispatcherRoutePreview(
      orderId: currentOrder?.id,
      routePlan: routePlan,
      routePoints: validRoutePoints,
    );

    final screenH = MediaQuery.of(context).size.height;
    final bottomSafe = MediaQuery.of(context).padding.bottom;
    final bottomPaddingForFab = (screenH * _sheetInitial) + 16 + bottomSafe;

    final route = controller.currentRoute;
    final canStart = controller.canStartNavigation;
    final canCalculateApproach =
        savedRoutePlan != null &&
        validRoutePoints.isNotEmpty &&
        orderDetailsAsync?.isLoading != true;

    final showRouteControls = route != null && hasOrder;

    final showChangeStatus = hasOrder;

    final String routeActionLabel;
    final IconData routeActionIcon;
    if (_isStartingNavigation) {
      routeActionLabel = 'Getting current location';
      routeActionIcon = Icons.my_location_rounded;
    } else if (controller.isFollowing) {
      routeActionLabel = t.route_stop;
      routeActionIcon = Icons.pause_rounded;
    } else if (!canStart && savedRoutePlan != null) {
      routeActionLabel = t.route_calculate_approach;
      routeActionIcon = Icons.alt_route_rounded;
    } else {
      routeActionLabel = t.route_start_route;
      routeActionIcon = Icons.play_arrow_rounded;
    }

    final sheetHeightNotifier = ValueNotifier<double>(screenH * _sheetInitial);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          buildRouteMapLayer(
            controller: controller,
            onBack: () => context.go('/home'),
            bottomPaddingForFab: bottomPaddingForFab,
            sheetHeightNotifier: sheetHeightNotifier,
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: NotificationListener<DraggableScrollableNotification>(
              onNotification: (notification) {
                final sheetHeight = screenH * notification.extent;
                sheetHeightNotifier.value = sheetHeight;
                return false;
              },
              child: DraggableScrollableSheet(
                expand: false,
                minChildSize: _sheetMin,
                initialChildSize: _sheetInitial,
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
                          Padding(
                            padding: EdgeInsets.fromLTRB(18, 10, 18, 0),
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

                                if (!hasOrder) ...[
                                  Text(
                                    t.route_no_order_title,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Figtree',
                                      color: Color(0xFF111827),
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    t.route_no_order_description,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Figtree',
                                      color: Color(0xFF6B7280),
                                      height: 1.35,
                                    ),
                                  ),
                                ] else ...[
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
                                    _LocationNotice(
                                      message: _locationPreparationMessage!,
                                    ),
                                    const SizedBox(height: 12),
                                  ] else ...[
                                    const SizedBox(height: 8),
                                  ],

                                  if (orderDetailsAsync?.isLoading == true) ...[
                                    Text(
                                      t.route_loading_route,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Figtree',
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                  ] else if (orderDetailsAsync?.hasError ==
                                      true) ...[
                                    Text(
                                      t.route_route_error,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Figtree',
                                        color: Color(0xFFEF4444),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                  ] else if (savedRoutePlan != null) ...[
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _InfoChip(
                                            label: t.route_distance_label,
                                            value:
                                                '${_formatKm(savedRoutePlan.distanceMeters)} km',
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: _InfoChip(
                                            label: t.route_time_label,
                                            value: _formatMin(
                                              t,
                                              Duration(
                                                seconds: savedRoutePlan
                                                    .durationSeconds,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    if (route != null) ...[
                                      Text(
                                        t.route_approach_label,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Figtree',
                                          color: Color(0xFF0F4D46),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _InfoChip(
                                              label: t.route_distance_label,
                                              value:
                                                  '${_formatKm(controller.remainingDistanceInMeters ?? route.lengthInMeters)} km',
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: _InfoChip(
                                              label: t.route_time_label,
                                              value: _formatMin(
                                                t,
                                                controller.remainingDuration ??
                                                    route.duration,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      if (controller.navigationInstruction !=
                                          null) ...[
                                        _InstructionCard(
                                          label: t.route_next_instruction_label,
                                          value:
                                              controller.navigationInstruction!,
                                        ),
                                        const SizedBox(height: 12),
                                      ],
                                    ],
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
                                  ] else if (!hasConfiguredRoute) ...[
                                    Text(
                                      t.route_no_configured_route,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Figtree',
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                  ] else if (route != null) ...[
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _InfoChip(
                                            label: t.route_distance_label,
                                            value:
                                                '${_formatKm(controller.remainingDistanceInMeters ?? route.lengthInMeters)} km',
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: _InfoChip(
                                            label: t.route_time_label,
                                            value: _formatMin(
                                              t,
                                              controller.remainingDuration ??
                                                  route.duration,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    if (controller.navigationInstruction !=
                                        null) ...[
                                      _InstructionCard(
                                        label: t.route_next_instruction_label,
                                        value:
                                            controller.navigationInstruction!,
                                      ),
                                      const SizedBox(height: 12),
                                    ],
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
                                  ] else ...[
                                    Text(
                                      t.route_route_not_calculated,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Figtree',
                                        color: Color(0xFF6B7280),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                  ],

                                  // GŁÓWNY PRZYCISK (trasa/nawigacja)
                                  SizedBox(
                                    height: 54,
                                    child: FilledButton(
                                      onPressed: controller.isCalculating ||
                                              _isStartingNavigation ||
                                              (!canStart &&
                                                  !canCalculateApproach)
                                          ? null
                                          : () async {
                                              if (controller.isFollowing) {
                                                controller.stopFollowing();
                                                return;
                                              }
                                              final messenger =
                                                  ScaffoldMessenger.of(context);
                                              if (!canStart) {
                                                final routePlanForApproach =
                                                    savedRoutePlan;
                                                if (!canCalculateApproach ||
                                                    routePlanForApproach ==
                                                        null) {
                                                  return;
                                                }
                                                final firstStop =
                                                    validRoutePoints.first;
                                                try {
                                                  await controller
                                                      .calculateApproachRouteToFirstStop(
                                                    firstStop: GeoCoordinates(
                                                      firstStop.latitude,
                                                      firstStop.longitude,
                                                    ),
                                                    routePlan:
                                                        routePlanForApproach,
                                                  );
                                                } catch (e) {
                                                  if (!mounted) return;
                                                  messenger.showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        e.toString(),
                                                      ),
                                                    ),
                                                  );
                                                  return;
                                                }
                                                final approachRoute =
                                                    controller.currentRoute;
                                                if (approachRoute != null) {
                                                  try {
                                                    await _locationReportingService
                                                        .reportApproachRoute(
                                                      transportOrderId:
                                                          currentOrder.id,
                                                      distanceMeters:
                                                          approachRoute
                                                              .lengthInMeters,
                                                      duration:
                                                          approachRoute.duration,
                                                    );
                                                  } catch (_) {
                                                    // Raport jest nieblokujący –
                                                    // błąd nie zatrzymuje UI.
                                                  }
                                                }
                                                return;
                                              }
                                              try {
                                                await _startNavigationAndReportLocation(
                                                  orderId: currentOrder.id,
                                                );
                                              } catch (_) {
                                                // _startNavigationAndReportLocation handles user-visible errors.
                                              }
                                            },
                                      style: FilledButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF0F4D46,
                                        ),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        elevation: 2,
                                      ),
                                      child: controller.isCalculating ||
                                              _isStartingNavigation
                                          ? const SizedBox(
                                              height: 22,
                                              width: 22,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2.5,
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  routeActionIcon,
                                                  size: 24,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  routeActionLabel,
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
                                  if (savedRoutePlan != null &&
                                      route != null &&
                                      !controller.isFollowing) ...[
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      height: 48,
                                      child: OutlinedButton(
                                        onPressed: controller.isCalculating
                                            ? null
                                            : controller.cancelApproachRoute,
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: const Color(
                                            0xFF111827,
                                          ),
                                          side: const BorderSide(
                                            color: Color(0xFFE5E7EB),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          t.common_cancel,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Figtree',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ),

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

class _InstructionCard extends StatelessWidget {
  const _InstructionCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE7EFE7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD6E4D6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              fontFamily: 'Figtree',
              color: Color(0xFF0F4D46),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              fontFamily: 'Figtree',
              color: Color(0xFF111827),
              height: 1.25,
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
