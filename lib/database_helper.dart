import 'dart:io';
import 'package:dokugaku/main.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = 'MyDatabase.db';
  static final _databaseVersion = 1;

  // シングルトン
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // アクセス用
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      print('_database is not null');
      return _database!;
    }

    print('_database is NULL');
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    print('initDatabase Start');

    var documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, _databaseName);

    // データベース削除
    //debugDelete();

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database database, int version) async {
    await database.execute('''
      CREATE TABLE memos(
        id TEXT PRIMARY KEY,
        created_at TEXT,
        updated_at TEXT,
        title TEXT,
        text TEXT
      )
    ''');
  }

  close(){
    _database?.close();
  }

  static debugDelete() async {
    instance.close();
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, _databaseName);
    _database = null;
    await deleteDatabase(path);

    print('Delete Database path=$path');
  }

  // ====== ヘルパーメソッド ======

  Future<MemoModel> insert(MemoModel memo) async {
    Database db = await instance.database;
    var id = await db.insert("memos", memo.toMap());
    return memo;
  }

  Future<int> getCount(String table) async{
    Database db = await instance.database;
    print('count table=$table');
    var result = await db.rawQuery('SELECT COUNT(*) FROM $table');
    var count = Sqflite.firstIntValue(result);
    return count!;
  }

  Future<List<MemoModel>> getMemos() async{
    var db = await instance.database;
    List<Map<String, Object?>> result = await db.query('memos');

    List<MemoModel> list = [];
    result.forEach((row) {
      list.add(MemoModel.fromMap(row));
      print(row.toString());
    });

    return list;
  }
}
