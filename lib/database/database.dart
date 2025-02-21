import 'package:dokusend/database/document_metadata.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(tables: [DocumentMetadata])
class DokuDb extends _$DokuDb {
  DokuDb._() : super(_openConnection());

  static final DokuDb _instance = DokuDb._();

  factory DokuDb() => _instance;

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'dokusend_db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
