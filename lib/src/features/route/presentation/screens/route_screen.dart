import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:here_sdk/core.dart';

import 'package:mobile/src/core/l10n/app_localizations.dart';
import 'package:mobile/src/features/orders/application/current_driver_order_provider.dart';
import 'package:mobile/src/features/orders/application/driver_order_details_provider.dart';
import 'package:mobile/src/features/orders/application/update_order_status_controller.dart';
import 'package:mobile/src/features/orders/domain/driver_transport_order_details.dart';
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

class RouteScreen extends ConsumerStatefulWidget {
  const RouteScreen({super.key});

  @override
  ConsumerState<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends ConsumerState<RouteScreen> {
  static const _sheetMin = 0.20;
  static const _sheetInitial = 0.30;
  static const _sheetMax = 0.70;

  String? _lastDispatcherPreviewKey;

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
  void dispose() {
    ref.read(routeMapControllerProvider).detachMap();
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

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final controller = ref.watch(routeMapControllerProvider);

    final currentOrderAsync = ref.watch(currentDriverOrderProvider);
    final currentOrder = currentOrderAsync.asData?.value;
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
    if (controller.isFollowing) {
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
          RouteMapLayer(
            controller: controller,
            bottomPaddingForFab: bottomPaddingForFab,
            sheetHeightNotifier: sheetHeightNotifier,
            onBack: () => context.go('/home'),
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
                                  const SizedBox(height: 8),

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
                                                return;
                                              }
                                              try {
                                                await controller
                                                    .startFollowing();
                                              } catch (e) {
                                                if (!mounted) return;
                                                messenger.showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      '${t.common_location}: $e',
                                                    ),
                                                  ),
                                                );
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
                                      child: controller.isCalculating
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
                                orderId: currentOrder!.id,
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
