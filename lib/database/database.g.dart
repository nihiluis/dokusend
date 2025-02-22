// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $DocumentMetadataTable extends DocumentMetadata
    with TableInfo<$DocumentMetadataTable, DocumentMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _versionMeta =
      const VerificationMeta('version');
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
      'version', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(1));
  @override
  List<GeneratedColumn> get $columns => [id, createdAt, updatedAt, version];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_metadata';
  @override
  VerificationContext validateIntegrity(
      Insertable<DocumentMetadataData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('version')) {
      context.handle(_versionMeta,
          version.isAcceptableOrUnknown(data['version']!, _versionMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  DocumentMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentMetadataData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      version: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}version'])!,
    );
  }

  @override
  $DocumentMetadataTable createAlias(String alias) {
    return $DocumentMetadataTable(attachedDatabase, alias);
  }
}

class DocumentMetadataData extends DataClass
    implements Insertable<DocumentMetadataData> {
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int version;
  const DocumentMetadataData(
      {required this.id,
      this.createdAt,
      this.updatedAt,
      required this.version});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['version'] = Variable<int>(version);
    return map;
  }

  DocumentMetadataCompanion toCompanion(bool nullToAbsent) {
    return DocumentMetadataCompanion(
      id: Value(id),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      version: Value(version),
    );
  }

  factory DocumentMetadataData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentMetadataData(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      version: serializer.fromJson<int>(json['version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'version': serializer.toJson<int>(version),
    };
  }

  DocumentMetadataData copyWith(
          {int? id,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          int? version}) =>
      DocumentMetadataData(
        id: id ?? this.id,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        version: version ?? this.version,
      );
  DocumentMetadataData copyWithCompanion(DocumentMetadataCompanion data) {
    return DocumentMetadataData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      version: data.version.present ? data.version.value : this.version,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentMetadataData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, updatedAt, version);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentMetadataData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.version == this.version);
}

class DocumentMetadataCompanion extends UpdateCompanion<DocumentMetadataData> {
  final Value<int> id;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> version;
  final Value<int> rowid;
  const DocumentMetadataCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentMetadataCompanion.insert({
    required int id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<DocumentMetadataData> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? version,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (version != null) 'version': version,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentMetadataCompanion copyWith(
      {Value<int>? id,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? version,
      Value<int>? rowid}) {
    return DocumentMetadataCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentMetadataCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('version: $version, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DocumentJobTable extends DocumentJob
    with TableInfo<$DocumentJobTable, DocumentJobData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentJobTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _documentIdMeta =
      const VerificationMeta('documentId');
  @override
  late final GeneratedColumn<int> documentId = GeneratedColumn<int>(
      'document_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumnWithTypeConverter<DocumentJobStatus, String>
      status = GeneratedColumn<String>('status', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('pending'))
          .withConverter<DocumentJobStatus>($DocumentJobTable.$converterstatus);
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns =>
      [id, createdAt, updatedAt, documentId, status, message];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_job';
  @override
  VerificationContext validateIntegrity(Insertable<DocumentJobData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('document_id')) {
      context.handle(
          _documentIdMeta,
          documentId.isAcceptableOrUnknown(
              data['document_id']!, _documentIdMeta));
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    context.handle(_statusMeta, const VerificationResult.success());
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  DocumentJobData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentJobData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      documentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}document_id'])!,
      status: $DocumentJobTable.$converterstatus.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!),
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message'])!,
    );
  }

  @override
  $DocumentJobTable createAlias(String alias) {
    return $DocumentJobTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DocumentJobStatus, String, String>
      $converterstatus =
      const EnumNameConverter<DocumentJobStatus>(DocumentJobStatus.values);
}

class DocumentJobData extends DataClass implements Insertable<DocumentJobData> {
  final String id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int documentId;
  final DocumentJobStatus status;
  final String message;
  const DocumentJobData(
      {required this.id,
      this.createdAt,
      this.updatedAt,
      required this.documentId,
      required this.status,
      required this.message});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['document_id'] = Variable<int>(documentId);
    {
      map['status'] =
          Variable<String>($DocumentJobTable.$converterstatus.toSql(status));
    }
    map['message'] = Variable<String>(message);
    return map;
  }

  DocumentJobCompanion toCompanion(bool nullToAbsent) {
    return DocumentJobCompanion(
      id: Value(id),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      documentId: Value(documentId),
      status: Value(status),
      message: Value(message),
    );
  }

  factory DocumentJobData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentJobData(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      documentId: serializer.fromJson<int>(json['documentId']),
      status: $DocumentJobTable.$converterstatus
          .fromJson(serializer.fromJson<String>(json['status'])),
      message: serializer.fromJson<String>(json['message']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'documentId': serializer.toJson<int>(documentId),
      'status': serializer
          .toJson<String>($DocumentJobTable.$converterstatus.toJson(status)),
      'message': serializer.toJson<String>(message),
    };
  }

  DocumentJobData copyWith(
          {String? id,
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent(),
          int? documentId,
          DocumentJobStatus? status,
          String? message}) =>
      DocumentJobData(
        id: id ?? this.id,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        documentId: documentId ?? this.documentId,
        status: status ?? this.status,
        message: message ?? this.message,
      );
  DocumentJobData copyWithCompanion(DocumentJobCompanion data) {
    return DocumentJobData(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      documentId:
          data.documentId.present ? data.documentId.value : this.documentId,
      status: data.status.present ? data.status.value : this.status,
      message: data.message.present ? data.message.value : this.message,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentJobData(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('documentId: $documentId, ')
          ..write('status: $status, ')
          ..write('message: $message')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, createdAt, updatedAt, documentId, status, message);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentJobData &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.documentId == this.documentId &&
          other.status == this.status &&
          other.message == this.message);
}

class DocumentJobCompanion extends UpdateCompanion<DocumentJobData> {
  final Value<String> id;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> documentId;
  final Value<DocumentJobStatus> status;
  final Value<String> message;
  final Value<int> rowid;
  const DocumentJobCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.documentId = const Value.absent(),
    this.status = const Value.absent(),
    this.message = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentJobCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    required int documentId,
    this.status = const Value.absent(),
    this.message = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        documentId = Value(documentId);
  static Insertable<DocumentJobData> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? documentId,
    Expression<String>? status,
    Expression<String>? message,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (documentId != null) 'document_id': documentId,
      if (status != null) 'status': status,
      if (message != null) 'message': message,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentJobCompanion copyWith(
      {Value<String>? id,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? documentId,
      Value<DocumentJobStatus>? status,
      Value<String>? message,
      Value<int>? rowid}) {
    return DocumentJobCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      documentId: documentId ?? this.documentId,
      status: status ?? this.status,
      message: message ?? this.message,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<int>(documentId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
          $DocumentJobTable.$converterstatus.toSql(status.value));
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentJobCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('documentId: $documentId, ')
          ..write('status: $status, ')
          ..write('message: $message, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$DokuDb extends GeneratedDatabase {
  _$DokuDb(QueryExecutor e) : super(e);
  $DokuDbManager get managers => $DokuDbManager(this);
  late final $DocumentMetadataTable documentMetadata =
      $DocumentMetadataTable(this);
  late final $DocumentJobTable documentJob = $DocumentJobTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [documentMetadata, documentJob];
}

typedef $$DocumentMetadataTableCreateCompanionBuilder
    = DocumentMetadataCompanion Function({
  required int id,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> version,
  Value<int> rowid,
});
typedef $$DocumentMetadataTableUpdateCompanionBuilder
    = DocumentMetadataCompanion Function({
  Value<int> id,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> version,
  Value<int> rowid,
});

class $$DocumentMetadataTableFilterComposer
    extends Composer<_$DokuDb, $DocumentMetadataTable> {
  $$DocumentMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnFilters(column));
}

class $$DocumentMetadataTableOrderingComposer
    extends Composer<_$DokuDb, $DocumentMetadataTable> {
  $$DocumentMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get version => $composableBuilder(
      column: $table.version, builder: (column) => ColumnOrderings(column));
}

class $$DocumentMetadataTableAnnotationComposer
    extends Composer<_$DokuDb, $DocumentMetadataTable> {
  $$DocumentMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);
}

class $$DocumentMetadataTableTableManager extends RootTableManager<
    _$DokuDb,
    $DocumentMetadataTable,
    DocumentMetadataData,
    $$DocumentMetadataTableFilterComposer,
    $$DocumentMetadataTableOrderingComposer,
    $$DocumentMetadataTableAnnotationComposer,
    $$DocumentMetadataTableCreateCompanionBuilder,
    $$DocumentMetadataTableUpdateCompanionBuilder,
    (
      DocumentMetadataData,
      BaseReferences<_$DokuDb, $DocumentMetadataTable, DocumentMetadataData>
    ),
    DocumentMetadataData,
    PrefetchHooks Function()> {
  $$DocumentMetadataTableTableManager(_$DokuDb db, $DocumentMetadataTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DocumentMetadataCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            version: version,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int id,
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> version = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DocumentMetadataCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            version: version,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DocumentMetadataTableProcessedTableManager = ProcessedTableManager<
    _$DokuDb,
    $DocumentMetadataTable,
    DocumentMetadataData,
    $$DocumentMetadataTableFilterComposer,
    $$DocumentMetadataTableOrderingComposer,
    $$DocumentMetadataTableAnnotationComposer,
    $$DocumentMetadataTableCreateCompanionBuilder,
    $$DocumentMetadataTableUpdateCompanionBuilder,
    (
      DocumentMetadataData,
      BaseReferences<_$DokuDb, $DocumentMetadataTable, DocumentMetadataData>
    ),
    DocumentMetadataData,
    PrefetchHooks Function()>;
typedef $$DocumentJobTableCreateCompanionBuilder = DocumentJobCompanion
    Function({
  required String id,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  required int documentId,
  Value<DocumentJobStatus> status,
  Value<String> message,
  Value<int> rowid,
});
typedef $$DocumentJobTableUpdateCompanionBuilder = DocumentJobCompanion
    Function({
  Value<String> id,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> documentId,
  Value<DocumentJobStatus> status,
  Value<String> message,
  Value<int> rowid,
});

class $$DocumentJobTableFilterComposer
    extends Composer<_$DokuDb, $DocumentJobTable> {
  $$DocumentJobTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get documentId => $composableBuilder(
      column: $table.documentId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<DocumentJobStatus, DocumentJobStatus, String>
      get status => $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnFilters(column));
}

class $$DocumentJobTableOrderingComposer
    extends Composer<_$DokuDb, $DocumentJobTable> {
  $$DocumentJobTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get documentId => $composableBuilder(
      column: $table.documentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get message => $composableBuilder(
      column: $table.message, builder: (column) => ColumnOrderings(column));
}

class $$DocumentJobTableAnnotationComposer
    extends Composer<_$DokuDb, $DocumentJobTable> {
  $$DocumentJobTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get documentId => $composableBuilder(
      column: $table.documentId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DocumentJobStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);
}

class $$DocumentJobTableTableManager extends RootTableManager<
    _$DokuDb,
    $DocumentJobTable,
    DocumentJobData,
    $$DocumentJobTableFilterComposer,
    $$DocumentJobTableOrderingComposer,
    $$DocumentJobTableAnnotationComposer,
    $$DocumentJobTableCreateCompanionBuilder,
    $$DocumentJobTableUpdateCompanionBuilder,
    (
      DocumentJobData,
      BaseReferences<_$DokuDb, $DocumentJobTable, DocumentJobData>
    ),
    DocumentJobData,
    PrefetchHooks Function()> {
  $$DocumentJobTableTableManager(_$DokuDb db, $DocumentJobTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentJobTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentJobTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentJobTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> documentId = const Value.absent(),
            Value<DocumentJobStatus> status = const Value.absent(),
            Value<String> message = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DocumentJobCompanion(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            documentId: documentId,
            status: status,
            message: message,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            required int documentId,
            Value<DocumentJobStatus> status = const Value.absent(),
            Value<String> message = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DocumentJobCompanion.insert(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            documentId: documentId,
            status: status,
            message: message,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DocumentJobTableProcessedTableManager = ProcessedTableManager<
    _$DokuDb,
    $DocumentJobTable,
    DocumentJobData,
    $$DocumentJobTableFilterComposer,
    $$DocumentJobTableOrderingComposer,
    $$DocumentJobTableAnnotationComposer,
    $$DocumentJobTableCreateCompanionBuilder,
    $$DocumentJobTableUpdateCompanionBuilder,
    (
      DocumentJobData,
      BaseReferences<_$DokuDb, $DocumentJobTable, DocumentJobData>
    ),
    DocumentJobData,
    PrefetchHooks Function()>;

class $DokuDbManager {
  final _$DokuDb _db;
  $DokuDbManager(this._db);
  $$DocumentMetadataTableTableManager get documentMetadata =>
      $$DocumentMetadataTableTableManager(_db, _db.documentMetadata);
  $$DocumentJobTableTableManager get documentJob =>
      $$DocumentJobTableTableManager(_db, _db.documentJob);
}
