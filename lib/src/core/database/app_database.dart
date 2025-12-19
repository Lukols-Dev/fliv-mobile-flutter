import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

import 'tables/driver_profile_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [DriverProfileTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    // opcjonalnie: włącz walidację przy starcie (pomaga łapać błędy)
    // beforeOpen: (details) async {
    //   await customStatement('PRAGMA foreign_keys = ON');
    // },
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
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/fliv.sqlite');
    return NativeDatabase(file);
  });
}
