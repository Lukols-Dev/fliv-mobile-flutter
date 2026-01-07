import 'package:drift/drift.dart';
import 'package:mobile/src/features/documents/domain/local_document_status.dart';

class DriverOrderDocumentTable extends Table {
  TextColumn get localId => text()();
  TextColumn get orderId => text()();
  TextColumn get title => text().withLength(min: 1, max: 255)();

  TextColumn get localPath => text()();

  TextColumn get mimeType => text()();
  IntColumn get sizeBytes => integer()();

  IntColumn get status => intEnum<LocalDocumentStatus>()();
  TextColumn get remoteId => text().nullable()();
  TextColumn get remoteUrl => text().nullable()();

  TextColumn get lastError => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {localId};
}
