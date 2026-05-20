import 'dart:io';
import 'package:dio/dio.dart';

import 'transport_order_documents_dto.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

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

  Future<TransportOrderDocumentDto> uploadForOrder({
    required String orderId,
    required File file,
    required String title,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      throw ArgumentError('title is required');
    }

    // MIME best-effort
    final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
    final parts = mimeType.split('/');
    final mediaType = parts.length == 2
        ? MediaType(parts[0], parts[1])
        : MediaType('image', 'jpeg');

    final formData = FormData.fromMap({
      'title': trimmedTitle,
      'file': await MultipartFile.fromFile(
        file.path,
        filename: p.basename(file.path),
        contentType: mediaType,
      ),
    });

    final res = await _dio.post(
      '/api/v1/driver/transport-orders/$orderId/documents',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );

    return TransportOrderDocumentDto.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> deleteForOrder({
    required String orderId,
    required String orderDocumentId,
  }) async {
    await _dio.delete(
      '/api/v1/driver/transport-orders/$orderId/documents/$orderDocumentId',
    );
  }
}
