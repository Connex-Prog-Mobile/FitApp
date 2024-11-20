import 'package:sqflite/sqflite.dart';

class WorkoutSheetRepository {
  final Database db;

  WorkoutSheetRepository(this.db);

  Future<int> insertWorkoutSheet(Map<String, dynamic> workoutSheet) async {
    return await db.insert('workout_sheets', workoutSheet);
  }

  Future<List<Map<String, dynamic>>> getAllWorkoutSheets() async {
    return await db.query('workout_sheets');
  }

  Future<List<Map<String, dynamic>>> getWorkoutSheetsByUserId(int userId) async {
    return await db.query('workout_sheets', where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<int> updateWorkoutSheet(int id, Map<String, dynamic> workoutSheet) async {
    return await db.update('workout_sheets', workoutSheet, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteWorkoutSheet(int id) async {
    return await db.delete('workout_sheets', where: 'id = ?', whereArgs: [id]);
  }
}
