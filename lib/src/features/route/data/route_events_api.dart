import 'package:dio/dio.dart';

class RouteEventsApi {
  RouteEventsApi(this._dio);
  final Dio _dio;

  Future<void> reportEvent({
    required String orderId,
    required String eventType,
    String? description,
  }) async {
    await _dio.post(
      '/api/v1/driver/transport-orders/$orderId/events',
      data: {
        'eventType': eventType,
        if (description != null && description.trim().isNotEmpty)
          'description': description.trim(),
      },
    );
  }
}
