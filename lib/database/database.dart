import 'package:dokusend/database/document_job.dart';
import 'package:dokusend/database/document_image.dart';
import 'package:dokusend/database/document_metadata.dart';
import 'package:dokusend/database/document_tag.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(tables: [DocumentMetadata, DocumentJob, DocumentImage, DocumentTag])
class DokuDb extends _$DokuDb {
  static final DokuDb _instance = DokuDb._internal();

  factory DokuDb() {
    return _instance;
  }

  DokuDb._internal() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(documentMetadata, documentMetadata.name);
          }
          if (from < 3) {
            await m.addColumn(documentMetadata, documentMetadata.type);
          }
          if (from < 4) {
            await m.addColumn(documentMetadata, documentMetadata.caption);
          }
          if (from < 5) {
            await m.createTable(documentImage);
          }
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'dokusend_db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
