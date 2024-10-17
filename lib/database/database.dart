import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

import 'dao/todo_response_dao.dart';

part 'database.g.dart';

// Todo Responses table
class TodoResponse extends Table {
  IntColumn get id => integer().named("_id").autoIncrement()();
  TextColumn get data => text().named("data")();
  TextColumn get createdAt => text().named("created_at")();
  TextColumn? get updatedAt => text().named("updated_at").nullable()();
  BoolColumn get isCompleted =>
      boolean().named("isCompleted").withDefault(const Constant(false))();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, "gatt.sqlite"));
    return NativeDatabase(file);
  });
}

@DriftDatabase(
  tables: [
    TodoResponse,
  ],
  daos: [
    TodoResponseDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // Database version
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {},
    );
  }
}
