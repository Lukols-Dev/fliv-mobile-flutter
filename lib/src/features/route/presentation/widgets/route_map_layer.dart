import 'package:flutter/material.dart';
import 'package:here_sdk/mapview.dart';

import 'package:mobile/src/features/route/presentation/controllers/route_map_controller.dart';

class RouteMapLayer extends StatelessWidget {
  const RouteMapLayer({
    super.key,
    required this.controller,
    required this.onBack,
    required this.bottomPaddingForFab,
  });

  final RouteMapController controller;
  final VoidCallback onBack;
  final double bottomPaddingForFab;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HereMap(onMapCreated: (map) => controller.onMapCreated(map)),

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
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
              ),
            ),
          ),
        ),

        // CENTER
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
    );
  }
}
