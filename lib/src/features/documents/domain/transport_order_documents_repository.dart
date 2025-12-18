import 'transport_order_document.dart';

abstract class TransportOrderDocumentsRepository {
  Future<List<TransportOrderDocument>> listForOrder({required String orderId});
}
