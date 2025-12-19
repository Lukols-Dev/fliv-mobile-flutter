import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

import 'tables/driver_profile_table.dart';
import 'tables/driver_current_order_table.dart';
import 'tables/driver_order_details_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    DriverProfileTable,
    DriverCurrentOrderTable,
    DriverOrderDetailsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

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

  Future<void> clearAllOrders() async {
    await delete(driverCurrentOrderTable).go();
    await delete(driverOrderDetailsTable).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/fliv.sqlite');
    return NativeDatabase(file);
  });
}
