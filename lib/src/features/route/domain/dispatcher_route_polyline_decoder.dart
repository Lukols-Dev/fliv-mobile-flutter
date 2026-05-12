import 'package:flexible_polyline_dart/flutter_flexible_polyline.dart';
import 'package:flexible_polyline_dart/latlngz.dart';

class DispatcherRoutePolylineDecoder {
  const DispatcherRoutePolylineDecoder();

  List<List<RoutePreviewCoordinate>> decodeSections(String polyline) {
    return polyline
        .split('|')
        .map((section) => section.trim())
        .where((section) => section.isNotEmpty)
        .map(_decodeSection)
        .where((section) => section.length >= 2)
        .toList(growable: false);
  }

  List<RoutePreviewCoordinate> _decodeSection(String section) {
    final List<LatLngZ> decoded = FlexiblePolyline.decode(section);

    return decoded.map((point) {
      return RoutePreviewCoordinate(
        latitude: point.lat,
        longitude: point.lng,
      );
    }).toList(growable: false);
  }
}

class RoutePreviewCoordinate {
  const RoutePreviewCoordinate({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;
}
