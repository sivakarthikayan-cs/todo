// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $TodoResponseTable extends TodoResponse
    with TableInfo<$TodoResponseTable, TodoResponseData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodoResponseTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      '_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'isCompleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("isCompleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, data, isCompleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todo_response';
  @override
  VerificationContext validateIntegrity(Insertable<TodoResponseData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('_id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['_id']!, _idMeta));
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('isCompleted')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['isCompleted']!, _isCompletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TodoResponseData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoResponseData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}_id'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}isCompleted'])!,
    );
  }

  @override
  $TodoResponseTable createAlias(String alias) {
    return $TodoResponseTable(attachedDatabase, alias);
  }
}

class TodoResponseData extends DataClass
    implements Insertable<TodoResponseData> {
  final int id;
  final String data;
  final bool isCompleted;
  const TodoResponseData(
      {required this.id, required this.data, required this.isCompleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['_id'] = Variable<int>(id);
    map['data'] = Variable<String>(data);
    map['isCompleted'] = Variable<bool>(isCompleted);
    return map;
  }

  TodoResponseCompanion toCompanion(bool nullToAbsent) {
    return TodoResponseCompanion(
      id: Value(id),
      data: Value(data),
      isCompleted: Value(isCompleted),
    );
  }

  factory TodoResponseData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodoResponseData(
      id: serializer.fromJson<int>(json['id']),
      data: serializer.fromJson<String>(json['data']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'data': serializer.toJson<String>(data),
      'isCompleted': serializer.toJson<bool>(isCompleted),
    };
  }

  TodoResponseData copyWith({int? id, String? data, bool? isCompleted}) =>
      TodoResponseData(
        id: id ?? this.id,
        data: data ?? this.data,
        isCompleted: isCompleted ?? this.isCompleted,
      );
  TodoResponseData copyWithCompanion(TodoResponseCompanion data) {
    return TodoResponseData(
      id: data.id.present ? data.id.value : this.id,
      data: data.data.present ? data.data.value : this.data,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodoResponseData(')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, data, isCompleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodoResponseData &&
          other.id == this.id &&
          other.data == this.data &&
          other.isCompleted == this.isCompleted);
}

class TodoResponseCompanion extends UpdateCompanion<TodoResponseData> {
  final Value<int> id;
  final Value<String> data;
  final Value<bool> isCompleted;
  const TodoResponseCompanion({
    this.id = const Value.absent(),
    this.data = const Value.absent(),
    this.isCompleted = const Value.absent(),
  });
  TodoResponseCompanion.insert({
    this.id = const Value.absent(),
    required String data,
    this.isCompleted = const Value.absent(),
  }) : data = Value(data);
  static Insertable<TodoResponseData> custom({
    Expression<int>? id,
    Expression<String>? data,
    Expression<bool>? isCompleted,
  }) {
    return RawValuesInsertable({
      if (id != null) '_id': id,
      if (data != null) 'data': data,
      if (isCompleted != null) 'isCompleted': isCompleted,
    });
  }

  TodoResponseCompanion copyWith(
      {Value<int>? id, Value<String>? data, Value<bool>? isCompleted}) {
    return TodoResponseCompanion(
      id: id ?? this.id,
      data: data ?? this.data,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['_id'] = Variable<int>(id.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (isCompleted.present) {
      map['isCompleted'] = Variable<bool>(isCompleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodoResponseCompanion(')
          ..write('id: $id, ')
          ..write('data: $data, ')
          ..write('isCompleted: $isCompleted')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TodoResponseTable todoResponse = $TodoResponseTable(this);
  late final TodoResponseDao todoResponseDao =
      TodoResponseDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [todoResponse];
}

typedef $$TodoResponseTableCreateCompanionBuilder = TodoResponseCompanion
    Function({
  Value<int> id,
  required String data,
  Value<bool> isCompleted,
});
typedef $$TodoResponseTableUpdateCompanionBuilder = TodoResponseCompanion
    Function({
  Value<int> id,
  Value<String> data,
  Value<bool> isCompleted,
});

class $$TodoResponseTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TodoResponseTable> {
  $$TodoResponseTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get data => $state.composableBuilder(
      column: $state.table.data,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isCompleted => $state.composableBuilder(
      column: $state.table.isCompleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$TodoResponseTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TodoResponseTable> {
  $$TodoResponseTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get data => $state.composableBuilder(
      column: $state.table.data,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isCompleted => $state.composableBuilder(
      column: $state.table.isCompleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $$TodoResponseTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TodoResponseTable,
    TodoResponseData,
    $$TodoResponseTableFilterComposer,
    $$TodoResponseTableOrderingComposer,
    $$TodoResponseTableCreateCompanionBuilder,
    $$TodoResponseTableUpdateCompanionBuilder,
    (
      TodoResponseData,
      BaseReferences<_$AppDatabase, $TodoResponseTable, TodoResponseData>
    ),
    TodoResponseData,
    PrefetchHooks Function()> {
  $$TodoResponseTableTableManager(_$AppDatabase db, $TodoResponseTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TodoResponseTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TodoResponseTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> data = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
          }) =>
              TodoResponseCompanion(
            id: id,
            data: data,
            isCompleted: isCompleted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String data,
            Value<bool> isCompleted = const Value.absent(),
          }) =>
              TodoResponseCompanion.insert(
            id: id,
            data: data,
            isCompleted: isCompleted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TodoResponseTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TodoResponseTable,
    TodoResponseData,
    $$TodoResponseTableFilterComposer,
    $$TodoResponseTableOrderingComposer,
    $$TodoResponseTableCreateCompanionBuilder,
    $$TodoResponseTableUpdateCompanionBuilder,
    (
      TodoResponseData,
      BaseReferences<_$AppDatabase, $TodoResponseTable, TodoResponseData>
    ),
    TodoResponseData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TodoResponseTableTableManager get todoResponse =>
      $$TodoResponseTableTableManager(_db, _db.todoResponse);
}
