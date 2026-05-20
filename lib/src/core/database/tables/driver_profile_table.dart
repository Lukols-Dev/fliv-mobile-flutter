import 'package:drift/drift.dart';

class DriverProfileTable extends Table {
  TextColumn get key => text()();

  TextColumn get firstName => text()();
  TextColumn get lastName => text()();

  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();

  TextColumn get companyInternalId => text().nullable()();
  TextColumn get driverCode => text().nullable()();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get medicalExamExpiry => dateTime().nullable()();
  DateTimeColumn get psychologicalExamExpiry => dateTime().nullable()();
  DateTimeColumn get tachographCardExpiry => dateTime().nullable()();
  DateTimeColumn get licenseExpiry => dateTime().nullable()();
  DateTimeColumn get visaExpiry => dateTime().nullable()();
  DateTimeColumn get workPermitExpiry => dateTime().nullable()();
  DateTimeColumn get residenceCardExpiry => dateTime().nullable()();
  DateTimeColumn get driverCertificateExpiry => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {key};
}
