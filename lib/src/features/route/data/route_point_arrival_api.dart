import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/core/network/dio_provider.dart';

final routePointArrivalApiProvider = Provider<RoutePointArrivalApi>(
  (ref) => RoutePointArrivalApi(ref.read(dioProvider)),
);

class RoutePointArrivalApi {
  const RoutePointArrivalApi(this._dio);

  final Dio _dio;

  Future<void> confirmArrival({
    required String orderId,
    required String routePointId,
    required int sequence,
    required DateTime confirmedAt,
    required double latitude,
    required double longitude,
  }) async {
    await _dio.post(
      '/api/v1/driver/transport-orders/$orderId/route-points/$routePointId/arrival',
      data: {
        'sequence': sequence,
        'confirmedAt': confirmedAt.toUtc().toIso8601String(),
        'latitude': latitude,
        'longitude': longitude,
      },
    );
  }
}
