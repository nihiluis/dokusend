import 'package:dokusend/database/database.dart';
import 'package:drift/drift.dart';

class DocumentTag extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

class DocumentTagRepository {
  final DokuDb db;

  DocumentTagRepository() : db = DokuDb();

  Future<DocumentTagData> create(String name) async {
    final now = DateTime.now();
    final documentTag = DocumentTagCompanion(
      name: Value(name),
      createdAt: Value(now),
      updatedAt: Value(now),
    );

    return await db.into(db.documentTag).insertReturning(documentTag);
  }

  Future<DocumentTagData?> findById(int id) async {
    return await (db.select(db.documentTag)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<DocumentTagData>> getAll() async {
    return await db.select(db.documentTag).get();
  }
}
