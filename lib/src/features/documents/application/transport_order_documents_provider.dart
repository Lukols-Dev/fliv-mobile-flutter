import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/transport_order_documents_repository_impl.dart';
import '../domain/transport_order_document.dart';

final transportOrderDocumentsProvider =
    FutureProvider.family<List<TransportOrderDocument>, String>((ref, orderId) {
      final repo = ref.read(transportOrderDocumentsRepositoryProvider);
      return repo.listForOrder(orderId: orderId);
    });
