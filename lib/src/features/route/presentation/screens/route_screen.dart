import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:here_sdk/mapview.dart';

import 'package:mobile/src/features/route/presentation/controllers/route_map_controller.dart';

class RouteScreen extends ConsumerWidget {
  const RouteScreen({super.key});

  static const _sheetMin = 0.12;
  static const _sheetInitial = 0.18;
  static const _sheetMax = 0.55;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(routeMapControllerProvider);

    final screenH = MediaQuery.of(context).size.height;
    final bottomPaddingForFab = (screenH * _sheetInitial) + 16;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          HereMap(onMapCreated: controller.onMapCreated),

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

          // DRAGGABLE BOTTOM SHEET - od samego dołu + działa drag
          DraggableScrollableSheet(
            minChildSize: _sheetMin,
            initialChildSize: _sheetInitial,
            maxChildSize: _sheetMax,
            // ważne: nie dokładaj SafeArea na wrapperze, bo odsunie od dołu
            builder: (context, scrollController) {
              final bottomInset = MediaQuery.of(context).padding.bottom;

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
                child: ListView(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(18, 10, 18, 22 + bottomInset),
                  children: const [
                    // drag handle
                    Align(alignment: Alignment.center, child: _DragHandle()),
                    SizedBox(height: 14),

                    Text(
                      'Aktualne zlecenie',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Figtree',
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    SizedBox(height: 4),

                    Text(
                      'Brak przypisanego aktualnie zlecenia',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Figtree',
                        color: Color(0xFF111827),
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 220),
                  ],
                ),
              );
            },
          ),

          // CENTER BUTTON (bottom-right, above the sheet)
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

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18,
      child: Center(
        child: Container(
          width: 44,
          height: 5,
          decoration: BoxDecoration(
            color: Color(0xFFE5E7EB),
            borderRadius: BorderRadius.all(Radius.circular(999)),
          ),
        ),
      ),
    );
  }
}
