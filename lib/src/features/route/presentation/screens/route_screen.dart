import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:here_sdk/mapview.dart';

import 'package:mobile/src/features/route/presentation/controllers/route_map_controller.dart';

class RouteScreen extends ConsumerWidget {
  const RouteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(routeMapControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: HereMap(onMapCreated: controller.onMapCreated),
    );
  }
}
