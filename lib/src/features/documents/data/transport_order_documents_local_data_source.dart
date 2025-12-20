import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/src/core/database/app_database.dart';
import 'package:mobile/src/core/database/app_database_provider.dart';
import 'package:mobile/src/features/documents/domain/local_document_status.dart';

final orderDocumentsLocalDataSourceProvider =
    Provider<OrderDocumentsLocalDataSource>((ref) {
      return OrderDocumentsLocalDataSource(ref.read(appDatabaseProvider));
    });

class OrderDocumentsLocalDataSource {
  OrderDocumentsLocalDataSource(this._db);
  final AppDatabase _db;

  Stream<List<DriverOrderDocumentTableData>> watchForOrder(String orderId) =>
      _db.watchDocumentsForOrder(orderId);

  Future<DriverOrderDocumentTableData?> getByLocalId(String localId) =>
      _db.getDocumentByLocalId(localId);

  Future<void> upsert(DriverOrderDocumentTableCompanion row) =>
      _db.upsertDocument(row);

  Future<void> setStatus({
    required String localId,
    required LocalDocumentStatus status,
    String? remoteId,
    String? remoteUrl,
    String? lastError,
  }) => _db.updateDocumentStatus(
    localId: localId,
    status: status,
    remoteId: remoteId,
    remoteUrl: remoteUrl,
    lastError: lastError,
  );

  Future<void> clearForOrder(String orderId) =>
      _db.clearDocumentsForOrder(orderId);
  Future<void> clearAll() => _db.clearAllDocuments();
}
