import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stream_provider_app/userModel.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'users.db');
    return openDatabase(path, version: 1, onCreate: _createDatabase, onConfigure: _configureDatabase);
  }

  Future<void> _configureDatabase(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, email TEXT)');
  }

  Future<List<User>> getUsers() async {
    try {
      Database db = await instance.database;
      List<Map<String, dynamic>> maps = await db.query('users');
      return List.generate(maps.length, (i) {
        return User.fromMap(maps[i]);
      });
    } catch (e) {
      // Handle error
      print("Error fetching users: $e");
      return [];
    }
  }

  Future<int> insertUser(User user) async {
    try {
      Database db = await instance.database;
      return await db.insert('users', user.toMap());
    } catch (e) {
      // Handle error
      print("Error inserting user: $e");
      return -1;
    }
  }

  Future<int> updateUser(User user) async {
    try {
      Database db = await instance.database;
      return await db.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
    } catch (e) {
      // Handle error
      print("Error updating user: $e");
      return -1;
    }
  }

  Future<int> deleteUser(int id) async {
    try {
      Database db = await instance.database;
      return await db.delete('users', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      // Handle error
      print("Error deleting user: $e");
      return -1;
    }
  }
}
