import 'package:FitApp/application/infra/database/models/workouts.model.dart';
import 'package:sqflite/sqflite.dart';

class WorkoutRepository {
  final Database db;

  WorkoutRepository(this.db);

  Future<int> insertWorkout(Map<String, dynamic> workout) async {
    print('### Inserting workout: $workout');
    final result = await db.insert('workouts', workout);
    print('### Workout inserted with result: $result');
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllWorkouts() async {
    print('### Retrieving all workouts');
    final result = await db.query('workouts');
    print('### All workouts retrieved: ${result.length}');
    return result;
  }

  Future<List<Workout>> getAllMappedWorkouts() async {
    print('### Retrieving all workouts');
    final List<Map<String, dynamic>> maps = await db.query('workouts');
    print('### All workouts retrieved: $maps');
    return maps.map((map) => Workout.fromMap(map)).toList();
  }

  Future<List<Map<String, dynamic>>> getWorkoutsByUserId(int userId) async {
    print('### Retrieving workouts for userId: $userId');
    final result =
        await db.query('workouts', where: 'user_id = ?', whereArgs: [userId]);
    print('### Workouts for userId $userId retrieved: ${result.length}');
    return result;
  }

  Future<int> updateWorkout(int id, Map<String, dynamic> workout) async {
    print('### Updating workout with id: $id, data: $workout');
    final result =
        await db.update('workouts', workout, where: 'id = ?', whereArgs: [id]);
    print('### Workout updated, result: $result');
    return result;
  }

  Future<int> deleteWorkout(int id) async {
    print('### Deleting workout with id: $id');
    final result =
        await db.delete('workouts', where: 'id = ?', whereArgs: [id]);
    print('### Workout deleted, result: $result');
    return result;
  }
}
