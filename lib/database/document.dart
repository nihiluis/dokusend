import 'package:dokusend/database/database.dart';
import 'package:dokusend/utils/logger.dart';
import 'package:drift/drift.dart';

class DocumentMetadata extends Table {
  IntColumn get id => integer()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get version => integer().withDefault(Constant(1))();
}

enum DocumentJobStatus { pending, processing, completed, failed }

class DocumentJob extends Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get documentId => integer()();
  TextColumn get status =>
      textEnum<DocumentJobStatus>().withDefault(const Constant('pending'))();
  TextColumn get message => text().withDefault(const Constant(''))();
}

class DocumentMetadataRepository {
  final DokuDb db;

  DocumentMetadataRepository() : db = DokuDb();

  Future<int> create(int id) async {
    final now = DateTime.now();
    final metadataWithTimestamps = DocumentMetadataCompanion(
      id: Value(id),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
    return await db.into(db.documentMetadata).insert(metadataWithTimestamps);
  }

  Future<DocumentMetadataData?> findById(int id) async {
    return await (db.select(db.documentMetadata)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<DocumentMetadataData>> getAll() async {
    return await db.select(db.documentMetadata).get();
  }

  Future<bool> update(DocumentMetadataCompanion metadata, int id) async {
    final metadataWithTimestamp = metadata.copyWith(
      updatedAt: Value(DateTime.now()),
    );
    return await (db.update(db.documentMetadata)
              ..where((tbl) => tbl.id.equals(id)))
            .write(metadataWithTimestamp) >
        0;
  }

  Future<int> delete(int id) async {
    return await (db.delete(db.documentMetadata)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}

class DocumentJobRepository {
  final DokuDb db;

  DocumentJobRepository() : db = DokuDb();

  Future<void> create(String id, int documentId) async {
    final now = DateTime.now();
    final jobWithTimestamps = DocumentJobCompanion(
      id: Value(id),
      documentId: Value(documentId),
      createdAt: Value(now),
      updatedAt: Value(now),
    );
    logger.i('Creating document job: id=$id, documentId=$documentId');
    await db.into(db.documentJob).insert(jobWithTimestamps);
    logger.i('Document job created successfully');
  }

  Future<DocumentJobData?> findById(String id) async {
    return await (db.select(db.documentJob)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<DocumentJobData>> getAll() async {
    return await db.select(db.documentJob).get();
  }

  Future<List<DocumentJobData>> findByDocumentId(int documentId) async {
    return await (db.select(db.documentJob)
          ..where((tbl) => tbl.documentId.equals(documentId)))
        .get();
  }

  Future<bool> update(DocumentJobCompanion job, String id) async {
    final jobWithTimestamp = job.copyWith(
      updatedAt: Value(DateTime.now()),
    );
    return await (db.update(db.documentJob)..where((tbl) => tbl.id.equals(id)))
            .write(jobWithTimestamp) >
        0;
  }

  Future<int> delete(String id) async {
    return await (db.delete(db.documentJob)..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}
