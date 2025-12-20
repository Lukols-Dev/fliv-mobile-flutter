import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../domain/transport_order_document.dart';
import '../domain/transport_order_documents_repository.dart';
import 'transport_order_documents_api.dart';

final transportOrderDocumentsApiProvider = Provider<TransportOrderDocumentsApi>(
  (ref) => TransportOrderDocumentsApi(ref.read(dioProvider)),
);

final transportOrderDocumentsRepositoryProvider =
    Provider<TransportOrderDocumentsRepository>((ref) {
      return TransportOrderDocumentsRepositoryImpl(
        ref.read(transportOrderDocumentsApiProvider),
      );
    });

class TransportOrderDocumentsRepositoryImpl
    implements TransportOrderDocumentsRepository {
  TransportOrderDocumentsRepositoryImpl(this._api);

  final TransportOrderDocumentsApi _api;

  @override
  Future<List<TransportOrderDocument>> listForOrder({
    required String orderId,
  }) async {
    final items = await _api.listForOrder(orderId: orderId);
    return items.map((e) => e.toDomain()).toList();
  }

  @override
  Future<TransportOrderDocument> uploadForOrder({
    required String orderId,
    required File file,
    required String title,
  }) async {
    final dto = await _api.uploadForOrder(
      orderId: orderId,
      file: file,
      title: title,
    );
    return dto.toDomain();
  }
}
