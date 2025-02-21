import 'package:drift/drift.dart';

class DocumentMetadata extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get initialJobId => text().nullable()();
}

class DocumentJob extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  TextColumn get jobId => text()();
  TextColumn get documentId => text()();
  TextColumn get status => text()();
  TextColumn get message => text()();
}