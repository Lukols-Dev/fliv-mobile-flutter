import 'package:drift/drift.dart';

class DriverProfileTable extends Table {
  TextColumn get key => text()();

  TextColumn get firstName => text()();
  TextColumn get lastName => text()();

  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();

  TextColumn get companyInternalId => text().nullable()();
  TextColumn get driverCode => text().nullable()();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {key};
}
