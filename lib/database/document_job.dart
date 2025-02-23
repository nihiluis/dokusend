import 'package:dokusend/database/database.dart';
import 'package:dokusend/utils/logger.dart';
import 'package:drift/drift.dart';

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

class DocumentJobRepository {
  final DokuDb db;

  DocumentJobRepository() : db = DokuDb();

  Future<void> create(
      String id, int documentId, DocumentJobStatus status) async {
    final now = DateTime.now();
    final jobWithTimestamps = DocumentJobCompanion(
      id: Value(id),
      status: Value(status),
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

  Future<DocumentJobData?> findByDocumentId(int documentId) async {
    return await (db.select(db.documentJob)
          ..where((tbl) => tbl.documentId.equals(documentId)))
        .getSingleOrNull();
  }

  Future<List<DocumentJobData>> findByDocumentIdsIn(
      List<int> documentIds) async {
    return await (db.select(db.documentJob)
          ..where((tbl) => tbl.documentId.isIn(documentIds)))
        .get();
  }

  Future<List<DocumentJobData>> getAll() async {
    return await db.select(db.documentJob).get();
  }

  Future<void> updateStatus(String id, DocumentJobStatus status) async {
    await (db.update(db.documentJob)..where((tbl) => tbl.id.equals(id)))
        .write(DocumentJobCompanion(status: Value(status)));
  }

  Future<int> delete(String id) async {
    return await (db.delete(db.documentJob)..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}
