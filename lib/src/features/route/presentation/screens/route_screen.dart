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
    final dispatcherStops = routePoints
        .where(_isValidRoutePoint)
        .map((point) => GeoCoordinates(point.latitude, point.longitude))
        .toList(growable: false);
    final hasConfiguredRoute = dispatcherStops.isNotEmpty;

    final screenH = MediaQuery.of(context).size.height;
    final bottomSafe = MediaQuery.of(context).padding.bottom;
    final bottomPaddingForFab = (screenH * _sheetInitial) + 16 + bottomSafe;

    final route = controller.currentRoute;

    final canCalculate =
        hasOrder && hasConfiguredRoute && orderDetailsAsync?.isLoading != true;
    final canStart = controller.canStartNavigation;

    final showRouteControls = route != null && hasOrder;

    final showChangeStatus = hasOrder;

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

          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              final sheetHeight = screenH * notification.extent;
              sheetHeightNotifier.value = sheetHeight;
              return false;
            },
            child: DraggableScrollableSheet(
              minChildSize: _sheetMin,
              initialChildSize: _sheetInitial,
              maxChildSize: _sheetMax,
              builder: (context, scrollController) {
                return Container(
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
                                      value: controller.navigationInstruction!,
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
                                    onPressed: (!canStart && !canCalculate)
                                        ? null
                                        : () async {
                                      if (!canStart) {
                                        if (!canCalculate) return;
                                        try {
                                          await controller
                                              .calculateRouteOnDemand(
                                                dispatcherStops:
                                                    dispatcherStops,
                                              );
                                          if (controller.canStartNavigation) {
                                            await controller.startFollowing();
                                          }
                                        } catch (e) {
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '${t.route_route_error}: $e',
                                              ),
                                            ),
                                          );
                                        }
                                        return;
                                      }

                                      if (controller.isFollowing) {
                                        controller.stopFollowing();
                                      } else {
                                        try {
                                          await controller.startFollowing();
                                        } catch (e) {
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '${t.common_location}: $e',
                                              ),
                                            ),
                                          );
                                        }
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
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          controller.isFollowing
                                              ? Icons.pause_rounded
                                              : Icons.play_arrow_rounded,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          !canStart
                                              ? t.route_start_route
                                              : (controller.isFollowing
                                                    ? t.route_stop
                                                    : t.route_start_route),
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
                            padding: const EdgeInsets.fromLTRB(18, 18, 18, 60),
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
