import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';

final routeMapControllerProvider = Provider<RouteMapController>((ref) {
  return RouteMapController();
});

class RouteMapController {
  void onMapCreated(HereMapController hereMapController) {
    // Camera like in HERE (Berlin)
    const double distanceToEarthInMeters = 8000;
    final mapMeasureZoom = MapMeasure(
      MapMeasureKind.distanceInMeters,
      distanceToEarthInMeters,
    );

    hereMapController.camera.lookAtPointWithMeasure(
      GeoCoordinates(52.530932, 13.384915),
      mapMeasureZoom,
    );

    // Load scene
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay, (
      MapError? error,
    ) {
      if (error != null) {
        //TODO:change this to logger/sentry
        print('Map scene not loaded. MapError: ${error.toString()}');
      }
    });
  }
}
