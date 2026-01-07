import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/transport_order_documents_local_data_source.dart';
import '../../../core/database/app_database.dart';

final localOrderDocumentsProvider =
    StreamProvider.family<List<DriverOrderDocumentTableData>, String>((
      ref,
      orderId,
    ) {
      final ds = ref.read(orderDocumentsLocalDataSourceProvider);
      return ds.watchForOrder(orderId);
    });
