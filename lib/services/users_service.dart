import 'dart:ffi';

import 'package:sqflite/sqflite.dart';
import '../model/user.dart';
import 'database_helper.dart';

class UsersService {
  Future<int> addUser(User user) async {
    try {
      Database? db = await DatabaseHelper.initDatabase();

      // Check if user with the same email or phone number already exists
      List<Map<String, dynamic>> userMaps = await db!.query(
        DatabaseHelper.userTable,
        where: 'email = ? OR phoneNumber = ?',
        whereArgs: [user.email, user.phoneNumber],
      );
      if (userMaps.isNotEmpty) {
        return -1;
      } else {
        // Insert the user into the local SQLite database
        int userId = await db.insert(
          DatabaseHelper.userTable,
          {
            'email': user.email?.toLowerCase(),
            'phoneNumber': user.phoneNumber,
            'fullName': user.fullName?.toLowerCase(),
            'nbChallenge': 0,
            'nbChallengeDone': 0,
            'estimatedTime': 0,
            'actualTime': 0,
            'score': 0.0,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        return userId;
      }
    } catch (e) {
      print(e);
      return -5;
    }
  }


  Future<List<User>> getUsers() async {
    try {
      Database? db = await DatabaseHelper.initDatabase();

      List<Map<String, dynamic>> userMaps =
      await db!.query(DatabaseHelper.userTable);

      List<User> users = [];
      for (var userMap in userMaps) {
        User user = User(
          id: userMap['id'],
          email: userMap['email'],
          phoneNumber: userMap['phoneNumber'],
          fullName: userMap['fullName'],
          nbChallenge: userMap['nbChallenge'],
          nbChallengeDone: userMap['nbChallengeDone'],
          estimatedTime: userMap['estimatedTime'],
          actualTime: userMap['actualTime'],
          score: double.parse(userMap['score'].toString()),
        );
        users.add(user);
      }

      users.sort((a, b) => a.score!.compareTo(b.score!));

      return users;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<void> updateUserData(int userId, Map<String, dynamic> data) async {
    try {
      Database? db = await DatabaseHelper.initDatabase();

      // Update user data in the local SQLite database
      await db!.update(
        DatabaseHelper.userTable,
        data,
        where: 'id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      Database? db = await DatabaseHelper.initDatabase();

      await db!.delete(
        DatabaseHelper.userTable,
        where: 'id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String?> getUserIdByEmailOrPhone(String? email, String? phoneNumber) async {
    try {
      Database? db = await DatabaseHelper.initDatabase();

      // Query the local SQLite database to find a user with the given email or phone number
      List<Map<String, dynamic>> userMaps = await db!.query(
        DatabaseHelper.userTable,
        where: 'email = ? OR phoneNumber = ?',
        whereArgs: [email, phoneNumber],
      );

      // If a user with the provided email or phone number is found, return its id
      if (userMaps.isNotEmpty) {
        return userMaps.first['id'];
      } else {
        return null; // User not found
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String?> getUserNameById(String? id) async {
    try {
      Database? db = await DatabaseHelper.initDatabase();

      // Query the local SQLite database to find a user with the given email or phone number
      List<Map<String, dynamic>> userMaps = await db!.query(
        DatabaseHelper.userTable,
        where: 'id = ?',
        whereArgs: [id],
      );

      // If a user with the provided email or phone number is found, return its id
      if (userMaps.isNotEmpty) {
        return userMaps.first['fullName'];
      } else {
        return null; // User not found
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

}
