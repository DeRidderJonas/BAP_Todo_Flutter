import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

final String tableTasks = "tasks";
final String columnId = "id";
final String columnTitle = "title";
final String columnDone = "done";
final String columnDeadline = "deadline";
final String columnExtra = "extra";

class Task {
  int id;
  String title;
  bool done;
  String deadline;
  String extra;

  Task(){
    title = "";
    done = false;
    deadline = "";
    extra = "None";
  }

  Task.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    done = map[columnDone] == 1;
    deadline = map[columnDeadline];
    extra = map[columnExtra];
  }

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      columnTitle: title,
      columnDone: done,
      columnDeadline: deadline,
      columnExtra: extra
    };
    if(id != null && id != -1) {
      map[columnId] = id;
    }
    return map;
  }
}

class DatabaseHelper {
  static final _databaseName = "tasks.db";
  static final _databaseVersion = 3;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async{
    if(_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    Sqflite.devSetDebugModeOn(true);
    return await openDatabase(path,
      version: _databaseVersion,
      onCreate: (Database db, int version) async {
        await db.execute('''
          create table $tableTasks(
            $columnId integer primary key,
            $columnTitle text,
            $columnDone integer,
            $columnDeadline text,
            $columnExtra text
          )
        ''');
      }
    );
  }

  Future<int> insert(Task task) async{
    Database db = await database;
    //print(await db.query("sqlite_master"));
    int id = await db.insert(tableTasks, task.toMap());
    return id;
  }

  Future<Task> getById(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableTasks,
      columns: [columnId, columnTitle, columnDone, columnDeadline, columnExtra],
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if(maps.length>0){
      return Task.fromMap(maps.first);
    }
    return null;
  }

  Future<int> update(Task task) async {
    Database db = await database;
    return await db.update(tableTasks, task.toMap(),
      where: '$columnId = ?',
      whereArgs: [task.id]
    );
  }

  Future<List<Task>> getAll() async{
    Database db = await database;
    List<Map> maps = await db.query(tableTasks,
    columns: [columnId, columnTitle, columnDone, columnDeadline, columnExtra]);
    List<Task> tasks = [];
    maps.forEach((m) => tasks.insert(0, Task.fromMap(m)));
    return tasks;
  }
}
