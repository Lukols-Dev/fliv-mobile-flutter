import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';

import 'package:mobile/src/features/orders/application/current_driver_order_provider.dart';
import 'package:mobile/src/features/route/presentation/controllers/route_map_controller.dart';

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
  static const _sheetMin = 0.12;
  static const _sheetInitial = 0.18;
  static const _sheetMax = 0.55;

  String _formatKm(int meters) => (meters / 1000).toStringAsFixed(1);
  String _formatMin(Duration d) => '${(d.inSeconds / 60).round()} min';

  List<GeoCoordinates> _exampleStopsFromDispatcher() {
    // TODO: tutaj będzie umieszczana wartość z api, jak juz będę mieć lokalizacje punktów.
    // Docelowo: [zaladunek, rozladunek, ...punktyPoDrodze]
    return <GeoCoordinates>[
      GeoCoordinates(37.4064, -122.406417), // Poznań (POPRAWNE)
      GeoCoordinates(37.1079, -122.406417), // Wrocław (POPRAWNE)
    ];
  }

  @override
  void dispose() {
    ref.read(routeMapControllerProvider).detachMap();
    super.dispose();
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

    // stan przycisków:
    final canCalculate = hasOrder;
    final canStart = controller.canStartNavigation;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          HereMap(
            onMapCreated: (map) {
              controller.onMapCreated(map);
            },
          ),

          // BACK
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 2,
                  child: IconButton(
                    tooltip: 'Back',
                    onPressed: () => context.go('/home'),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                ),
              ),
            ),
          ),

          // DRAGGABLE SHEET
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
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(18, 10, 18, 18 + bottomSafe),
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
                            'Zlecenie #${currentOrder!.ztNumber}',
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

                          // GŁÓWNY PRZYCISK:
                          SizedBox(
                            height: 54,
                            child: FilledButton(
                              onPressed: () async {
                                // 1) jeśli nie ma trasy -> wyznacz
                                if (!canStart) {
                                  if (!canCalculate) return;

                                  final stops = _exampleStopsFromDispatcher();
                                  await controller.calculateRouteOnDemand(
                                    dispatcherStops: stops,
                                  );
                                  return;
                                }

                                // 2) jeśli trasa jest -> start/stop follow
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

                        const SizedBox(height: 220),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // CENTER BUTTON
          SafeArea(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPaddingForFab),
                child: Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 3,
                  child: IconButton(
                    tooltip: 'Wycentruj na mojej lokalizacji',
                    icon: const Icon(Icons.my_location_rounded),
                    onPressed: () async {
                      try {
                        await controller.refreshAndCenter();
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lokalizacja: $e')),
                        );
                      }
                    },
                  ),
                ),
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
