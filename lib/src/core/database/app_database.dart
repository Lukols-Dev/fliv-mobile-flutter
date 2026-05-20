import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:mobile/src/features/documents/domain/local_document_status.dart';
import 'package:path_provider/path_provider.dart';

import 'tables/driver_profile_table.dart';
import 'tables/driver_current_order_table.dart';
import 'tables/driver_order_details_table.dart';
import 'tables/driver_order_document_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    DriverProfileTable,
    DriverCurrentOrderTable,
    DriverOrderDetailsTable,
    DriverOrderDocumentTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // upgrade z v1 -> v2 (dodajemy kolumny do driverProfileTable)
      if (from < 2) {
        await m.addColumn(
          driverProfileTable,
          driverProfileTable.medicalExamExpiry,
        );
        await m.addColumn(
          driverProfileTable,
          driverProfileTable.psychologicalExamExpiry,
        );
        await m.addColumn(
          driverProfileTable,
          driverProfileTable.tachographCardExpiry,
        );
        await m.addColumn(driverProfileTable, driverProfileTable.licenseExpiry);
        await m.addColumn(driverProfileTable, driverProfileTable.visaExpiry);
        await m.addColumn(
          driverProfileTable,
          driverProfileTable.residenceCardExpiry,
        );
        await m.addColumn(
          driverProfileTable,
          driverProfileTable.driverCertificateExpiry,
        );
      }
      // upgrade z v2 -> v3 (dodajemy workPermitExpiry)
      if (from < 3) {
        await m.addColumn(
          driverProfileTable,
          driverProfileTable.workPermitExpiry,
        );
      }
      if (from < 4) {
        await m.createTable(driverCurrentOrderTable);
        await m.createTable(driverOrderDetailsTable);
      }
      if (from < 5) {
        await m.createTable(driverOrderDocumentTable);
      }
      // upgrade z v5 -> v6 (dodajemy fromAddress i toAddress do driverOrderDetailsTable)
      if (from < 6) {
        await m.addColumn(
          driverOrderDetailsTable,
          driverOrderDetailsTable.fromAddress,
        );
        await m.addColumn(
          driverOrderDetailsTable,
          driverOrderDetailsTable.toAddress,
        );
      }
      // upgrade z v6 -> v7 (cache punktów trasy dla nawigacji HERE)
      if (from < 7) {
        await m.addColumn(
          driverOrderDetailsTable,
          driverOrderDetailsTable.routePointsJson,
        );
      }
      // upgrade z v7 -> v8 (GPS odometr per zlecenie)
      if (from < 8) {
        await m.addColumn(
          driverOrderDetailsTable,
          driverOrderDetailsTable.gpsOdometerMeters,
        );
      }
      // upgrade z v8 -> v9 (avatar URL w profilu kierowcy)
      if (from < 9) {
        await m.addColumn(
          driverProfileTable,
          driverProfileTable.avatarUrl,
        );
      }
      // upgrade z v9 -> v10 (dane płatnika/klienta w offline cache)
      if (from < 10) {
        await m.addColumn(
          driverOrderDetailsTable,
          driverOrderDetailsTable.payerName,
        );
        await m.addColumn(
          driverOrderDetailsTable,
          driverOrderDetailsTable.payerEmail,
        );
      }
    },
  );

  // --- Driver profile (singleton: key = 'me') ---

  Stream<DriverProfileTableData?> watchMyDriverProfile() {
    return (select(
      driverProfileTable,
    )..where((t) => t.key.equals('me'))).watchSingleOrNull();
  }

  Future<DriverProfileTableData?> getMyDriverProfile() {
    return (select(
      driverProfileTable,
    )..where((t) => t.key.equals('me'))).getSingleOrNull();
  }

  Future<void> upsertMyDriverProfile(DriverProfileTableCompanion row) async {
    await into(driverProfileTable).insertOnConflictUpdate(row);
  }

  // --- Current order (singleton: key='current') ---

  Stream<DriverCurrentOrderTableData?> watchCurrentOrder() {
    return (select(
      driverCurrentOrderTable,
    )..where((t) => t.key.equals('current'))).watchSingleOrNull();
  }

  Future<DriverCurrentOrderTableData?> getCurrentOrder() {
    return (select(
      driverCurrentOrderTable,
    )..where((t) => t.key.equals('current'))).getSingleOrNull();
  }

  Future<void> upsertCurrentOrder(DriverCurrentOrderTableCompanion row) async {
    await into(driverCurrentOrderTable).insertOnConflictUpdate(row);
  }

  Future<void> clearCurrentOrder() async {
    await (delete(
      driverCurrentOrderTable,
    )..where((t) => t.key.equals('current'))).go();
  }

  // --- Order details (by id) ---

  Future<DriverOrderDetailsTableData?> getOrderDetails(String id) {
    return (select(
      driverOrderDetailsTable,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Stream<DriverOrderDetailsTableData?> watchOrderDetails(String id) {
    return (select(
      driverOrderDetailsTable,
    )..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  Future<void> upsertOrderDetails(DriverOrderDetailsTableCompanion row) async {
    await into(driverOrderDetailsTable).insertOnConflictUpdate(row);
  }

  Future<int> getOrderOdometer(String orderId) async {
    final row = await getOrderDetails(orderId);
    return row?.gpsOdometerMeters ?? 0;
  }

  Future<void> saveOrderOdometer(String orderId, int meters) async {
    await (update(driverOrderDetailsTable)..where((t) => t.id.equals(orderId)))
        .write(DriverOrderDetailsTableCompanion(
          gpsOdometerMeters: Value(meters),
          updatedAt: Value(DateTime.now()),
        ));
  }

  Future<void> clearAllOrders() async {
    await delete(driverCurrentOrderTable).go();
    await delete(driverOrderDetailsTable).go();
  }

  // --- DOCUMENTS ---
  Stream<List<DriverOrderDocumentTableData>> watchDocumentsForOrder(
    String orderId,
  ) =>
      (select(driverOrderDocumentTable)
            ..where((t) => t.orderId.equals(orderId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Future<List<DriverOrderDocumentTableData>> getDocumentsForOrder(
    String orderId,
  ) =>
      (select(driverOrderDocumentTable)
            ..where((t) => t.orderId.equals(orderId))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<DriverOrderDocumentTableData?> getDocumentByLocalId(String localId) =>
      (select(
        driverOrderDocumentTable,
      )..where((t) => t.localId.equals(localId))).getSingleOrNull();

  Future<void> deleteDocumentByLocalId(String localId) async {
    await (delete(
      driverOrderDocumentTable,
    )..where((t) => t.localId.equals(localId))).go();
  }

  Future<void> upsertDocument(DriverOrderDocumentTableCompanion row) async {
    await into(driverOrderDocumentTable).insertOnConflictUpdate(row);
  }

  Future<void> updateDocumentStatus({
    required String localId,
    required LocalDocumentStatus status,
    String? remoteId,
    String? remoteUrl,
    String? lastError,
  }) async {
    await (update(
      driverOrderDocumentTable,
    )..where((t) => t.localId.equals(localId))).write(
      DriverOrderDocumentTableCompanion(
        status: Value(status),
        remoteId: remoteId == null ? const Value.absent() : Value(remoteId),
        remoteUrl: remoteUrl == null ? const Value.absent() : Value(remoteUrl),
        lastError: Value(lastError),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateDocumentRemoteLink({
    required String localId,
    required String remoteId,
    required String remoteUrl,
  }) async {
    await (update(
      driverOrderDocumentTable,
    )..where((t) => t.localId.equals(localId))).write(
      DriverOrderDocumentTableCompanion(
        remoteId: Value(remoteId),
        remoteUrl: Value(remoteUrl),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> clearDocumentRemoteLink({
    required String localId,
    required LocalDocumentStatus status,
  }) async {
    await (update(
      driverOrderDocumentTable,
    )..where((t) => t.localId.equals(localId))).write(
      DriverOrderDocumentTableCompanion(
        status: Value(status),
        remoteId: const Value(null),
        remoteUrl: const Value(null),
        lastError: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> clearDocumentsForOrder(String orderId) async {
    await (delete(
      driverOrderDocumentTable,
    )..where((t) => t.orderId.equals(orderId))).go();
  }

  Future<void> clearAllDocuments() async {
    await delete(driverOrderDocumentTable).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/fliv.sqlite');
    return NativeDatabase(file);
  });
}
