import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/app_database_provider.dart';
import '../domain/driver_profile.dart';

final driverLocalDataSourceProvider = Provider<DriverLocalDataSource>((ref) {
  return DriverLocalDataSource(ref.read(appDatabaseProvider));
});

class DriverLocalDataSource {
  DriverLocalDataSource(this._db);

  final AppDatabase _db;

  static const _myKey = 'me';

  Stream<DriverProfile?> watchMyProfile() {
    return _db.watchMyDriverProfile().map(_rowToDomain);
  }

  Future<DriverProfile?> getMyProfile() async {
    final row = await _db.getMyDriverProfile();
    return _rowToDomain(row);
  }

  Future<void> upsertMyProfile(DriverProfile profile) {
    return _db.upsertMyDriverProfile(_domainToCompanion(profile));
  }

  Future<void> clearMyProfile() async {
    await (_db.delete(
      _db.driverProfileTable,
    )..where((t) => t.key.equals(_myKey))).go();
  }

  DriverProfile? _rowToDomain(DriverProfileTableData? row) {
    if (row == null) return null;

    return DriverProfile(
      firstName: row.firstName,
      lastName: row.lastName,
      email: row.email,
      phone: row.phone,
      companyInternalId: row.companyInternalId,
      driverCode: row.driverCode,
      // NOTE: document expiry fields are not yet persisted locally.
      // They will be filled from API when online.
    );
  }

  DriverProfileTableCompanion _domainToCompanion(DriverProfile profile) {
    return DriverProfileTableCompanion.insert(
      key: _myKey,
      firstName: profile.firstName,
      lastName: profile.lastName,
      email: profile.email == null
          ? const Value.absent()
          : Value(profile.email!),
      phone: profile.phone == null
          ? const Value.absent()
          : Value(profile.phone!),
      companyInternalId: profile.companyInternalId == null
          ? const Value.absent()
          : Value(profile.companyInternalId!),
      driverCode: profile.driverCode == null
          ? const Value.absent()
          : Value(profile.driverCode!),
    );
  }
}
