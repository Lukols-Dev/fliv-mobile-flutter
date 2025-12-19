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
    try {
      final row = await _db.getMyDriverProfile();
      return _rowToDomain(row);
    } catch (e) {
      // If database schema is outdated or query fails, return null
      // This allows the app to fallback to API fetch
      print('Error reading cached profile: $e');
      return null;
    }
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
      visaExpiresAt: row.visaExpiry,
      drivingLicenseExpiresAt: row.licenseExpiry,
      workPermitExpiresAt: row.workPermitExpiry,
      medicalCheckExpiresAt: row.medicalExamExpiry,
      psychCheckExpiresAt: row.psychologicalExamExpiry,
      driverCardExpiresAt: row.tachographCardExpiry,
      residenceCardExpiresAt: row.residenceCardExpiry,
      driverCertificateExpiresAt: row.driverCertificateExpiry,
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
      visaExpiry: profile.visaExpiresAt == null
          ? const Value.absent()
          : Value(profile.visaExpiresAt!),
      licenseExpiry: profile.drivingLicenseExpiresAt == null
          ? const Value.absent()
          : Value(profile.drivingLicenseExpiresAt!),
      workPermitExpiry: profile.workPermitExpiresAt == null
          ? const Value.absent()
          : Value(profile.workPermitExpiresAt!),
      medicalExamExpiry: profile.medicalCheckExpiresAt == null
          ? const Value.absent()
          : Value(profile.medicalCheckExpiresAt!),
      psychologicalExamExpiry: profile.psychCheckExpiresAt == null
          ? const Value.absent()
          : Value(profile.psychCheckExpiresAt!),
      tachographCardExpiry: profile.driverCardExpiresAt == null
          ? const Value.absent()
          : Value(profile.driverCardExpiresAt!),
      residenceCardExpiry: profile.residenceCardExpiresAt == null
          ? const Value.absent()
          : Value(profile.residenceCardExpiresAt!),
      driverCertificateExpiry: profile.driverCertificateExpiresAt == null
          ? const Value.absent()
          : Value(profile.driverCertificateExpiresAt!),
    );
  }
}
