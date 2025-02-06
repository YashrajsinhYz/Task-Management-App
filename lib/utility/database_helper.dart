import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_management/models/task_model.dart';

class DatabaseHelper {
  //Variables
  static const dbVersion = 1;
  static const dbName = "tasks.db";
  static const dbTable = "Tasks";
  static const columnId = "id";
  static const columnTitle = "title";
  static const columnDescription = "description";
  static const columnIsCompleted = "isCompleted";

  //initialize Database
  static Database? _database;

  // if _database empty, then goes _initDB & creates database. Otherwise returns _database.
  static Future<Database> get database async => _database ??= await _initDB();

  // Initialize DB
  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), dbName);
    return await openDatabase(path, version: dbVersion, onCreate: _onCreate);
  }

  // Create DB
  static FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE $dbTable($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnTitle TEXT NOT NULL, $columnDescription TEXT, $columnIsCompleted INTEGER DEFAULT 0 CHECK ($columnIsCompleted IN (0,1)))",
    );
  }

  // Insert Task to DB
  static Future<int> insertTask(TaskModel task) async {
    final db = await database;
    return await db.insert(dbTable, task.toMap(includeId: false));
  }

  // Fetch Tasks data from DB
  static Future<List<TaskModel>> fetchTasks() async {
    final db = await database;
    final result = await db.query(dbTable);
    return result.map((task) => TaskModel.fromMap(task)).toList();
  }

  static Future<void> updateTask(
      int id, String title, String description) async {
    final db = await database;
    await db.update(
        dbTable, {columnTitle: title, columnDescription: description},
        where: "id = ?", whereArgs: [id]);
  }

  static Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(dbTable, where: "id = ?", whereArgs: [id]);
  }

  static Future<void> updateTaskStatus(int id, bool isCompleted) async {
    final db = await database;
    await db.update(dbTable, {columnIsCompleted: isCompleted ? 1 : 0},
        where: "id = ?", whereArgs: [id]);
  }
}
