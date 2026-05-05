import 'package:drift/drift.dart';

class DriverOrderDetailsTable extends Table {
  TextColumn get id => text()();

  TextColumn get ztNumber => text().nullable()();
  TextColumn get status => text().nullable()();
  TextColumn get vehiclePlate => text().nullable()();
  TextColumn get trailerPlate => text().nullable()();
  TextColumn get clientName => text().nullable()();
  TextColumn get fromCountry => text().nullable()();
  TextColumn get fromAddress => text().nullable()();
  TextColumn get toCountry => text().nullable()();
  TextColumn get toAddress => text().nullable()();
  IntColumn get cargoWeightKg => integer().nullable()();
  DateTimeColumn get loadingDate => dateTime().nullable()();
  TextColumn get cargoDescription => text().nullable()();
  BoolColumn get temperatureSensitive => boolean().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get routePointsJson => text().nullable()();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
