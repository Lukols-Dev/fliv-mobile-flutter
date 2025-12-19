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
  int get schemaVersion => 1;

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
