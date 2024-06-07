import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String dbName = 'user.db';
  static const String userTable = 'user';

  static Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), dbName),
      onCreate: (db, version) {
        db.execute(
            '''
          CREATE TABLE $userTable(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            phoneNumber TEXT UNIQUE,
            fullName TEXT,
            nbChallenge INTEGER,
            nbChallengeDone INTEGER,
            estimatedTime INTEGER,
            actualTime INTEGER,
            score REAL
          )
          '''
        );
      },
      version: 1,
    );
  }
}
