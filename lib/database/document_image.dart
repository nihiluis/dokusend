import 'package:dokusend/database/database.dart';
import 'package:drift/drift.dart';

enum DocumentImageStatus { empty, completed }

class DocumentImage extends Table {
  IntColumn get id => integer()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get documentId => integer()();
  TextColumn get status =>
      textEnum<DocumentImageStatus>().withDefault(const Constant('empty'))();
  TextColumn get message => text().withDefault(const Constant(''))();
}

class DocumentImageRepository {
  final DokuDb db;

  DocumentImageRepository() : db = DokuDb();

  Future<DocumentImageData> create(
      int imageId, int documentId, DocumentImageStatus status) async {
    final now = DateTime.now();
    final documentImage = DocumentImageCompanion(
      id: Value(imageId),
      documentId: Value(documentId),
      status: Value(status),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    await db.into(db.documentImage).insert(documentImage);

    final documentImageData = await findById(imageId);

    if (documentImageData == null) {
      throw Exception('Document image not found');
    }

    return documentImageData;
  }

  Future<DocumentImageData?> findById(int id) async {
    return await (db.select(db.documentImage)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<DocumentImageData?> findByDocumentId(int documentId) async {
    return await (db.select(db.documentImage)
          ..where((tbl) => tbl.documentId.equals(documentId)))
        .getSingleOrNull();
  }

  Future<List<DocumentImageData>> findByDocumentIdsIn(
      List<int> documentIds) async {
    return await (db.select(db.documentImage)
          ..where((tbl) => tbl.documentId.isIn(documentIds)))
        .get();
  }

  Future<List<DocumentImageData>> getAll() async {
    return await db.select(db.documentImage).get();
  }

  Future<void> updateStatus(int id, DocumentImageStatus status) async {
    await (db.update(db.documentImage)..where((tbl) => tbl.id.equals(id)))
        .write(DocumentImageCompanion(status: Value(status)));
  }

  // Future<void> updateStatus(int imageId, DocumentImageStatus status) async {
  //   final now = DateTime.now();
  //   final documentImage = DocumentImageCompanion(
  //     status: Value(status),
  //     updatedAt: Value(now),
  //   );

  //   await (db.update(db.documentImage)..where((tbl) => tbl.id.equals(imageId)))
  //       .write(documentImage);
  // }
}
