import 'package:sqflite/sqflite.dart';

class WorkoutSetRepository {
  final Database db;

  WorkoutSetRepository(this.db);

  Future<int> insertWorkoutSet(Map<String, dynamic> workoutSet) async {
    return await db.insert('workout_sets', workoutSet);
  }

  Future<List<Map<String, dynamic>>> getWorkoutSetsByWorkoutId(int workoutId) async {
    return await db.query('workout_sets', where: 'workout_id = ?', whereArgs: [workoutId]);
  }

  Future<int> updateWorkoutSet(int id, Map<String, dynamic> workoutSet) async {
    return await db.update('workout_sets', workoutSet, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteWorkoutSet(int id) async {
    return await db.delete('workout_sets', where: 'id = ?', whereArgs: [id]);
  }
}
