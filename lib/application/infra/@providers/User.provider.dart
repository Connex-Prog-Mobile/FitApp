import 'package:fit_app/application/entities/schedule.entity.dart';
import 'package:fit_app/application/entities/user.entity.dart';
import 'package:fit_app/application/infra/database/repositories/user.repository.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  User? activeUser;
  final UserRepository _userRepository = UserRepository();

  final List<User> _usersList = [];

  List<User> get usersList => List.unmodifiable(_usersList);

  void addUser(User user) {
    if (!_usersList.any((u) => u.code == user.code)) {
      _usersList.add(user);
      notifyListeners();
    } else {
      print('o usuário já está cadastrado!');
    }
  }

  Future<void> addUserToDatabase(Map<String, dynamic> user) async {
    try {
      await _userRepository.insertUser(user);
    } catch (e) {
      throw Exception('Erro ao inserir usuário no banco de dados: $e');
    }
  }

  Future<bool> checkIfUserExists(String code, String email) async {
    final existingUserByCode = await _userRepository.getUserByCode(code);
    if (existingUserByCode != null) return true;

    final existingUserByEmail = await _userRepository.getUserByEmail(email);
    if (existingUserByEmail != null) return true;

    return false;
  }

  void addSchedule(Schedule schedule) {
    if (activeUser != null) {
      activeUser?.schedules.add(schedule);
    } else {
      print('usuário não encontrado');
    }
  }

  void logout() {
    activeUser?.isAuthenticated = false;
    notifyListeners();
  }

  Future<bool> validateUser(String code, String password) async {
    final userMap = await _userRepository.getUserByCode(code);

    if (userMap == null) return false;

    final isValid =
        _userRepository.validatePassword(password, userMap['password']);

    if (isValid) {
      activeUser = User(
        userMap['code'],
        userMap['password'],
        name: userMap['name'],
        email: userMap['email'],
        contact: userMap['contact'],
        isAuthenticated: true,
        isPersonalTrainer: userMap['is_personal_trainer'] == 1,
      );

      notifyListeners();
    }

    return isValid;
  }
}
