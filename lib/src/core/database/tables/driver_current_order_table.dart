import 'package:drift/drift.dart';

class DriverCurrentOrderTable extends Table {
  TextColumn get key => text()();
  TextColumn get id => text()();
  TextColumn get ztNumber => text()();
  TextColumn get status => text()();

  TextColumn get fromCountry => text().nullable()();
  TextColumn get toCountry => text().nullable()();
  DateTimeColumn get loadingDate => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {key};
}
