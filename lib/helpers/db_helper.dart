import 'package:chat_app/model/user.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'users.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user(userUid TEXT PRIMARY KEY, userName TEXT, userEmail TEXT, userProfileImage TEXT)');
    }, version: 1);
  }

  static Future<void> insertUser(User user) async {
    // Get a reference to the database.
    final db = await DBHelper.database();
    // Insert the User into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<User>> userList() async {
    // Get a reference to the database.
    final db = await DBHelper.database();
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('user');
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return User(
        maps[i]['userUid'],
        maps[i]['userName'],
        maps[i]['userEmail'],
        maps[i]['userProfileImage'],
      );
    });
  }
}
