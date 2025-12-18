import 'package:dio/dio.dart';

import 'driver_transport_orders_dto.dart';

class DriverTransportOrdersApi {
  DriverTransportOrdersApi(this._dio);

  final Dio _dio;

  Future<List<DriverTransportOrderListItemDto>> list({
    int page = 1,
    int limit = 1,
    String? status,
  }) async {
    final res = await _dio.get(
      '/api/v1/driver/transport-orders',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null && status.trim().isNotEmpty) 'status': status.trim(),
      },
    );

    final data = res.data;
    if (data is List) {
      return data
          .whereType<Map>()
          .map(
            (m) => DriverTransportOrderListItemDto.fromJson(
              m.cast<String, dynamic>(),
            ),
          )
          .toList();
    }

    throw const FormatException('Unexpected response for driver orders list');
  }

  Future<AssignDriverTransportOrderResponseDto> assign({
    required String ztNumber,
  }) async {
    final res = await _dio.post(
      '/api/v1/driver/transport-orders/assign',
      data: {'ztNumber': ztNumber},
    );

    return AssignDriverTransportOrderResponseDto.fromJson(
      res.data as Map<String, dynamic>,
    );
  }

  Future<DriverTransportOrderDetailsDto> getOne({required String id}) async {
    final res = await _dio.get('/api/v1/driver/transport-orders/$id');
    return DriverTransportOrderDetailsDto.fromJson(
      res.data as Map<String, dynamic>,
    );
  }
}
