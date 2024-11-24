import 'package:FitApp/application/infra/database/databaseHelper.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class UserRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await _dbHelper.database;
    user['password'] = _generateHash(user['password']);

    print('### Iniciando inserção de usuário... ###');
    var result = await db.insert('users', user);
    print('### Usuário inserido com sucesso. Resultado: $result ###');
    return result;
  }

  Future<List<Map<String, dynamic>>> searchUsersByName(String name) async {
    final db = await _dbHelper.database;

    print('### Pesquisando usuários com nome: $name ###');
    final results = await db.query(
      'users',
      where: 'name LIKE ?',
      whereArgs: ['%$name%'], 
    );

    print('### Resultados encontrados: $results ###');
    return results;
  }

  Future<void> deleteSchedulesByUserId(int userId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'schedules',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await _dbHelper.database;

    print('### Consultando todos os usuários... ###');
    var result = await db.query('users');
    print('### Usuários capturados: $result ###');
    return result;
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await _dbHelper.database;

    print('### Consultando usuário com email: $email ###');
    final result =
        await db.query('users', where: 'email = ?', whereArgs: [email]);
    print(
        '### Usuário encontrado: ${result.isNotEmpty ? result.first : 'Nenhum usuário encontrado'} ###');
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getUserByCode(String code) async {
    final db = await _dbHelper.database;

    print('### Consultando usuário com código: $code ###');
    final result =
        await db.query('users', where: 'code = ?', whereArgs: [code]);
    print(
        '### Usuário encontrado: ${result.isNotEmpty ? result.first : 'Nenhum usuário encontrado'} ###');
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await _dbHelper.database;

    print('### Consultando usuário com ID: $id ###');
    final result = await db.query('users', where: 'id = ?', whereArgs: [id]);
    print(
        '### Usuário encontrado: ${result.isNotEmpty ? result.first : 'Nenhum usuário encontrado'} ###');
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final db = await _dbHelper.database;
    print('### Atualizando usuário com ID: $id ###');
    var result =
        await db.update('users', user, where: 'id = ?', whereArgs: [id]);
    print('### Usuário atualizado com sucesso. Resultado: $result ###');
    return result;
  }

  Future<int> deleteUser(int id) async {
    final db = await _dbHelper.database;
    print('### Deletando usuário com ID: $id ###');
    var result = await db.delete('users', where: 'id = ?', whereArgs: [id]);
    print('### Usuário deletado com sucesso. Resultado: $result ###');
    return result;
  }

  bool validatePassword(String inputPassword, String storedHash) {
    final inputHash = _generateHash(inputPassword);
    print('### Validando senha... ###');
    bool isValid = inputHash == storedHash;
    print('### Senha ${isValid ? 'válida' : 'inválida'} ###');
    return isValid;
  }

  String _generateHash(String input) {
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }
}
