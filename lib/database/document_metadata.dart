import 'package:dokusend/database/database.dart';
import 'package:drift/drift.dart';

enum DocumentType {
  image,
  textFile,
  unknown,
}

class DocumentMetadata extends Table {
  IntColumn get id => integer()();
  TextColumn get type =>
      textEnum<DocumentType>().withDefault(const Constant('unknown'))();
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get caption => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get version => integer().withDefault(Constant(1))();
}

class DocumentMetadataRepository {
  final DokuDb db;

  DocumentMetadataRepository() : db = DokuDb();

  Future<int> create(int id, DocumentType documentType) async {
    final now = DateTime.now();
    final metadataWithTimestamps = DocumentMetadataCompanion(
      id: Value(id),
      type: Value(documentType),
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

  Future<List<DocumentMetadataData>> findAll(
      {int offset = 0, int limit = 10}) async {
    return await (db.select(db.documentMetadata)..limit(limit, offset: offset))
        .get();
  }

  Future<void> updateTitle(int id, String title) async {
    await (db.update(db.documentMetadata)..where((tbl) => tbl.id.equals(id)))
        .write(DocumentMetadataCompanion(
      name: Value(title),
      updatedAt: Value(DateTime.now()),
    ));
  }

  Future<void> updateCaption(int id, String caption) async {
    await (db.update(db.documentMetadata)..where((tbl) => tbl.id.equals(id)))
        .write(DocumentMetadataCompanion(
      caption: Value(caption),
      updatedAt: Value(DateTime.now()),
    ));
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
