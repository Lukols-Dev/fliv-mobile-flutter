import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:here_sdk/mapview.dart';

import 'package:mobile/src/features/route/presentation/controllers/route_map_controller.dart';

class RouteScreen extends ConsumerWidget {
  const RouteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(routeMapControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          HereMap(onMapCreated: controller.onMapCreated),
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
        ],
      ),
    );
  }
}
