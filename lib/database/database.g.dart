// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
abstract class _$DokuDb extends GeneratedDatabase {
  _$DokuDb(QueryExecutor e) : super(e);
  $DokuDbManager get managers => $DokuDbManager(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [];
}

class $DokuDbManager {
  final _$DokuDb _db;
  $DokuDbManager(this._db);
}
