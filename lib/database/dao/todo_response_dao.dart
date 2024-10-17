import 'package:drift/drift.dart';
import 'package:todo_app/database/database.dart';

part 'todo_response_dao.g.dart';

@DriftAccessor(tables: [TodoResponse])
class TodoResponseDao extends DatabaseAccessor<AppDatabase>
    with _$TodoResponseDaoMixin {
  TodoResponseDao(super.db);

  // clear table
  Future<int> clearTable() async {
    return await delete(todoResponse).go();
  }

  // insert todo response
  Future<int> addTodoResponse(
      TodoResponseCompanion todoResponseCompanion) async {
    return await into(todoResponse).insert(
      todoResponseCompanion,
      mode: InsertMode.insert,
    );
  }

  // Fetch list for todo item
  Future<List<TodoResponseData>> fetchTodoResponsesForSync() async {
    return await (select(todoResponse)..where((tbl) => tbl.id.isNotNull()))
        .get();
  }

  // Delete todo response record
  Future<int> deleteTodoResponseRecord(int id) async {
    return await (delete(todoResponse)..where((tbl) => tbl.id.equals(id))).go();
  }

// Delete multiple todo response records
  Future<int> deleteListOfTodoResponseRecords(List<int> ids) async {
    return await (delete(todoResponse)..where((tbl) => tbl.id.isIn(ids))).go();
  }

  // Update todo response
  Future<int> updateTodoResponseRecord(
      {required int id,
      String? value,
      bool? isCompleted,
      required String updateDate}) async {
    // Fetch the existing record
    final existingRecord = await (select(todoResponse)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingle();

    // Use the old value if the new value is null
    final newValue = value ?? existingRecord.data;

    return await (update(todoResponse)..where((tbl) => tbl.id.equals(id)))
        .write(TodoResponseCompanion(
            data: Value(newValue),
            isCompleted: Value(isCompleted ?? existingRecord.isCompleted),
            updatedAt: Value(updateDate)));
  }
}
