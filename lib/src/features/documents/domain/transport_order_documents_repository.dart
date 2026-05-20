import 'dart:io';
import 'transport_order_document.dart';

abstract class TransportOrderDocumentsRepository {
  Future<List<TransportOrderDocument>> listForOrder({required String orderId});
  Future<TransportOrderDocument> uploadForOrder({
    required String orderId,
    required File file,
    required String title,
  });

  Future<void> deleteForOrder({
    required String orderId,
    required String orderDocumentId,
  });
}
