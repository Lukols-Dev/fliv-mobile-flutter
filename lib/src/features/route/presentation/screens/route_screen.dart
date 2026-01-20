import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:here_sdk/core.dart';

import 'package:mobile/src/features/orders/application/current_driver_order_provider.dart';
import 'package:mobile/src/features/orders/application/update_order_status_controller.dart';
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
  String _formatMin(Duration d) => '${(d.inSeconds / 60).round()} min';

  List<GeoCoordinates> _exampleStopsFromDispatcher() => <GeoCoordinates>[
    GeoCoordinates(52.4064, 16.9252), // Poznań
    GeoCoordinates(51.1079, 17.0385), // Wrocław
  ];

  @override
  void dispose() {
    ref.read(routeMapControllerProvider).detachMap();
    super.dispose();
  }

  Future<void> _openChangeStatusSheet({required String orderId}) async {
    final selected = await showOrderStatusBottomSheet(context);

    if (!mounted) return;
    if (selected == null) return;

    final controller = ref.read(updateOrderStatusControllerProvider.notifier);

    try {
      await controller.updateStatus(orderId: orderId, status: selected.apiKey);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status zmieniony na: ${selected.titlePl}'),
          backgroundColor: const Color(0xFF0F4D46),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nie udało się zmienić statusu: ${e.toString()}'),
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
    final controller = ref.watch(routeMapControllerProvider);

    final currentOrderAsync = ref.watch(currentDriverOrderProvider);
    final currentOrder = currentOrderAsync.asData?.value;
    final hasOrder = currentOrder != null;

    final screenH = MediaQuery.of(context).size.height;
    final bottomSafe = MediaQuery.of(context).padding.bottom;
    final bottomPaddingForFab = (screenH * _sheetInitial) + 16 + bottomSafe;

    final route = controller.currentRoute;

    final canCalculate = hasOrder;
    final canStart = controller.canStartNavigation;

    final showRouteControls = route != null;

    final showChangeStatus = hasOrder;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          RouteMapLayer(
            controller: controller,
            bottomPaddingForFab: bottomPaddingForFab,
            onBack: () => context.go('/home'),
          ),

          DraggableScrollableSheet(
            minChildSize: _sheetMin,
            initialChildSize: _sheetInitial,
            maxChildSize: _sheetMax,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
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

                            const Text(
                              'Nawigacja',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                fontFamily: 'Figtree',
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(height: 6),

                            if (!hasOrder) ...[
                              const Text(
                                'Brak przypisanego aktualnie zlecenia.',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Figtree',
                                  color: Color(0xFF111827),
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Gdy dyspozytor przypisze zlecenie, tutaj pojawi się trasa oraz przycisk rozpoczęcia.',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Figtree',
                                  color: Color(0xFF6B7280),
                                  height: 1.35,
                                ),
                              ),
                            ] else ...[
                              Text(
                                'Zlecenie #${currentOrder.ztNumber}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'Figtree',
                                  color: Color(0xFF111827),
                                ),
                              ),
                              const SizedBox(height: 8),

                              if (route != null) ...[
                                Row(
                                  children: [
                                    Expanded(
                                      child: _InfoChip(
                                        label: 'Dystans',
                                        value:
                                            '${_formatKm(route.lengthInMeters)} km',
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: _InfoChip(
                                        label: 'Czas',
                                        value: _formatMin(route.duration),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                              ] else ...[
                                const Text(
                                  'Trasa: jeszcze nie wyznaczona.',
                                  style: TextStyle(
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
                                  onPressed: () async {
                                    if (!canStart) {
                                      if (!canCalculate) return;
                                      final stops =
                                          _exampleStopsFromDispatcher();
                                      await controller.calculateRouteOnDemand(
                                        dispatcherStops: stops,
                                      );
                                      return;
                                    }

                                    if (controller.isFollowing) {
                                      controller.stopFollowing();
                                    } else {
                                      controller.startFollowing();
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        !canStart
                                            ? Icons.route_rounded
                                            : (controller.isFollowing
                                                  ? Icons.pause_rounded
                                                  : Icons.play_arrow_rounded),
                                        size: 24,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        !canStart
                                            ? 'Wyznacz trasę'
                                            : (controller.isFollowing
                                                  ? 'Zatrzymaj'
                                                  : 'Rozpocznij trasę'),
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
                      if (!showRouteControls) ...[
                        const SizedBox(height: 18),
                        RouteControlsPanel(
                          isFollowing: controller.isFollowing,
                          onReportEvent: () =>
                              _openReportEventSheet(orderId: currentOrder!.id),
                          onPause: controller.stopFollowing,
                          onResume: controller.startFollowing,
                          onFinishRoute: () {},
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
                              child: const Text(
                                'Zmień status',
                                style: TextStyle(
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
