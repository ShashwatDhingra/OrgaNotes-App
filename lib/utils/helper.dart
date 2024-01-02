import 'dart:ffi';

import 'package:organotes/model/notes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PrefHelper {
  static const String TOKEN = 'user-token';
  static const String IS_BACKUP_ENABLED = 'is_backup_enabled';

  static SharedPreferences? _pref;

  static final PrefHelper _instance = PrefHelper._privateConstructor();

  // Add a static flag to ensure initialization only happens once
  static bool _initialized = false;

  PrefHelper._privateConstructor() {
    if (!_initialized) {
      throw Exception('Call initSharedPref() before using PrefHelper');
    }
  }

  factory PrefHelper() {
    return _instance;
  }

  static Future<void> initSharedPref() async {
    if (!_initialized) {
      _pref = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  Future<bool> setString(String key, String value) async {
    return await _pref!.setString(key, value);
  }

  String? getString(String key) {
    if (_pref!.containsKey(key)) {
      return _pref!.getString(key)!;
    } else {
      return null;
    }
  }

  Future<bool> setBool(String key, bool value) async {
    return _pref!.setBool(key, value);
  }

  bool? getBool(String key){
    return _pref!.getBool(key);
  }
}

class DBHelper {
  static const String _NOTES_DB = 'OrgaNotes_Database';
  static const String _NOTES_TABLE = 'notes';

  static Database? _db;

  // Private Contructor
  DBHelper._privateConstructor();

  // Singleton instance
  static final DBHelper _instatce = DBHelper._privateConstructor();

  // Getter to access the singleton instance
  factory DBHelper() {
    return _instatce;
  }

  Future<Database> get getDatabase async {
    if (_db != null) return _db!;
    _db = await initDatabase();
    return _db!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), '$_NOTES_DB.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $_NOTES_TABLE(id INTEGER PRIMARY KEY, deltaTitle TEXT, deltaDesc TEXT, title TEXT, desc TEXT, created TEXT, lastModified TEXT, isBackup INTEGER DEFAULT 0)');
  }

  Future<bool> insert(Note note) async {
    final db = await getDatabase;
    final res = await db.insert(_NOTES_TABLE, note.toJson());
    if (res == 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> delete(int id) async {
    final db = await getDatabase;
    final res =
        await db.delete(_NOTES_TABLE, where: 'id = ? ', whereArgs: [id]);
    if (res >= 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> update(Note note) async {
    final db = await getDatabase;
    final res = await db.update(_NOTES_TABLE, note.toJson(),
        where: 'id = ? ', whereArgs: [note.id]);
    if (res >= 1) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Note>> get() async {
    final db = await getDatabase;
    List<Map<String, dynamic>> data = await db.query(_NOTES_TABLE);
    return data.map((note) => Note.fromJson(note)).toList();
  }

  Future<bool> clear()async{
    final db = await getDatabase;
    final isCleared = await db.rawDelete('DELETE FROM $_NOTES_TABLE');
    if(isCleared > 0){
      return true;
    }else{
      return false;
    }
  }
}
