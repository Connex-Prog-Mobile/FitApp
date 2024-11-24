import 'package:sqflite/sqflite.dart';

class ScheduleRepository {
  final Database db;

  ScheduleRepository(this.db);

  Future<int> insertSchedule(Map<String, dynamic> schedule) async {
    print("### Iniciando a inserção do agendamento no banco de dados...");
    try {
      final result = await db.insert('schedules', schedule);
      print("### Agendamento inserido com sucesso! ID: $result");
      return result;
    } catch (e) {
      print("### Erro ao inserir agendamento: $e");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getAllSchedules() async {
    print("### Buscando todos os agendamentos do banco de dados...");
    try {
      final result = await db.query('schedules');
      print("### Encontrados ${result.length} agendamentos.");
      return result;
    } catch (e) {
      print("### Erro ao buscar agendamentos: $e");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getSchedulesByUserId(int userId) async {
    print("### Buscando agendamentos para o usuário ID: $userId...");
    try {
      final result = await db.query('schedules', where: 'user_id = ?', whereArgs: [userId]);
      print("### Encontrados ${result.length} agendamentos para o usuário.");
      return result;
    } catch (e) {
      print("### Erro ao buscar agendamentos por ID do usuário: $e");
      rethrow;
    }
  }

  Future<int> deleteSchedule(int id) async {
    print("### Iniciando a remoção do agendamento com ID: $id...");
    try {
      final result = await db.delete('schedules', where: 'id = ?', whereArgs: [id]);
      if (result > 0) {
        print("### Agendamento com ID: $id removido com sucesso.");
      } else {
        print("### Nenhum agendamento encontrado para o ID: $id.");
      }
      return result;
    } catch (e) {
      print("### Erro ao remover agendamento: $e");
      rethrow;
    }
  }
}
