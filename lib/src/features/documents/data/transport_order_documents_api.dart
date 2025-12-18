import 'package:dio/dio.dart';

import 'transport_order_documents_dto.dart';

class TransportOrderDocumentsApi {
  TransportOrderDocumentsApi(this._dio);

  final Dio _dio;

  Future<List<TransportOrderDocumentDto>> listForOrder({
    required String orderId,
  }) async {
    final res = await _dio.get(
      '/api/v1/driver/transport-orders/$orderId/documents',
    );

    final data = res.data;
    if (data is List) {
      return data
          .whereType<Map>()
          .map(
            (m) =>
                TransportOrderDocumentDto.fromJson(m.cast<String, dynamic>()),
          )
          .toList();
    }

    throw const FormatException(
      'Unexpected response for transport order documents list',
    );
  }
}
