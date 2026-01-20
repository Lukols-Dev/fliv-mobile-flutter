import 'package:flutter/material.dart';
import 'package:here_sdk/mapview.dart';

import 'package:mobile/src/features/route/presentation/controllers/route_map_controller.dart';

class RouteMapLayer extends StatelessWidget {
  const RouteMapLayer({
    super.key,
    required this.controller,
    required this.onBack,
    required this.bottomPaddingForFab,
    this.sheetHeightNotifier,
  });

  final RouteMapController controller;
  final VoidCallback onBack;
  final double bottomPaddingForFab;
  final ValueNotifier<double>? sheetHeightNotifier;

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
            child: sheetHeightNotifier != null
                ? ValueListenableBuilder<double>(
                    valueListenable: sheetHeightNotifier!,
                    builder: (context, sheetHeight, _) {
                      final screenHeight = MediaQuery.of(context).size.height;
                      final bottomPadding =
                          sheetHeight +
                          10 +
                          MediaQuery.of(context).padding.bottom;

                      // Próg, przy którym przycisk się ukrywa (np. 50% wysokości ekranu)
                      final hideThreshold = screenHeight * 0.5;
                      final shouldHide = sheetHeight > hideThreshold;

                      return AnimatedOpacity(
                        opacity: shouldHide ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: IgnorePointer(
                          ignoring: shouldHide,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              16,
                              16,
                              16,
                              bottomPadding,
                            ),
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
                                      SnackBar(
                                        content: Text('Lokalizacja: $e'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Padding(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      16,
                      16,
                      bottomPaddingForFab,
                    ),
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
