import 'package:sqflite/sqflite.dart';

class ScheduleRepository {
  final Database db;

  ScheduleRepository(this.db);

  Future<int> insertSchedule(Map<String, dynamic> schedule) async {
    return await db.insert('schedules', schedule);
  }

  Future<List<Map<String, dynamic>>> getAllSchedules() async {
    return await db.query('schedules');
  }

  Future<List<Map<String, dynamic>>> getSchedulesByUserId(int userId) async {
    return await db.query('schedules', where: 'user_id = ?', whereArgs: [userId]);
  }

  Future<int> deleteSchedule(int id) async {
    return await db.delete('schedules', where: 'id = ?', whereArgs: [id]);
  }
}
