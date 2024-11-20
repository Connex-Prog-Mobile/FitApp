import 'package:sqflite/sqflite.dart';

class WorkoutRepository {
  final Database db;

  WorkoutRepository(this.db);

  Future<int> insertWorkout(Map<String, dynamic> workout) async {
    return await db.insert('workouts', workout);
  }

  Future<List<Map<String, dynamic>>> getAllWorkouts() async {
    return await db.query('workouts');
  }

  Future<List<Map<String, dynamic>>> getWorkoutsByUserId(int userId) async {
    return await db.query('workouts', where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<int> updateWorkout(int id, Map<String, dynamic> workout) async {
    return await db.update('workouts', workout, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteWorkout(int id) async {
    return await db.delete('workouts', where: 'id = ?', whereArgs: [id]);
  }
}
