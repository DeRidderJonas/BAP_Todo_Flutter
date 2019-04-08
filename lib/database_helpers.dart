import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

final String tableTasks = "tasks";
final String columnId = "id";
final String columnTitle = "title";
final String columnDone = "done";

class Task {
  int id;
  String title;
  bool done;

  Task(){
    title = "";
    done = false;
  }

  Task.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    done = map[columnDone] == 1;
  }

  Map<String, dynamic> toMap(){
    var map = <String, dynamic>{
      columnTitle: title,
      columnDone: done
    };
    if(id != null && id != -1) {
      map[columnId] = id;
    }
    return map;
  }
}

class DatabaseHelper {
  static final _databaseName = "tasks.db";
  static final _databaseVersion = 1;

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
    return await openDatabase(path,
      version: _databaseVersion,
      onCreate: (Database db, int version) async {
        await db.execute('''
          create table $tableTasks(
            $columnId integer primary key,
            $columnTitle text,
            $columnDone integer
          )
        ''');
      }
    );
  }

  Future<int> insert(Task task) async{
    Database db = await database;
    int id = await db.insert(tableTasks, task.toMap());
    return id;
  }

  Future<Task> getById(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableTasks,
      columns: [columnId, columnTitle, columnDone],
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
}
