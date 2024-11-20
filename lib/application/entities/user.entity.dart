import 'package:fit_app/application/entities/schedule.entity.dart';

class User {
  String _code;
  String _password;
  String _name;
  String _email;
  String _contact;
  final List<Schedule> _schedules;
  bool _isAuthenticated;
  bool _isPersonalTrainer;

  User(this._code, this._password,
      {String name = '',
      String email = '',
      String contact = '',
      List<Schedule>? schedules,
      bool isAuthenticated = false,
      bool isPersonalTrainer = false})
      : _name = name,
        _email = email,
        _contact = contact,
        _schedules = schedules ?? [],
        _isAuthenticated = isAuthenticated,
        _isPersonalTrainer = isPersonalTrainer;

  String get code => _code;
  String get password => _password;
  String get name => _name;
  String get email => _email;
  String get contact => _contact;
  List<Schedule> get schedules => _schedules;
  bool get isAuthenticated => _isAuthenticated;
  bool get isPersonalTrainer => _isPersonalTrainer;

  set code(String value) => _code = value;
  set password(String value) => _password = value;
  set name(String value) => _name = value;
  set email(String value) => _email = value;
  set contact(String value) => _contact = value;
  set isAuthenticated(bool value) => _isAuthenticated = value;
  set isPersonalTrainer(bool value) => _isPersonalTrainer = value;

  String text() {
    return 'Nome: $_name, Email: $_email, Código: $_code, Senha: $_password, é personal: ${isPersonalTrainer ? "sim" : "não"}';
  }
}

class Trainer extends User {
  List<User> _clients;

  Trainer(
    super.code,
    super.password, {
    super.name,
    super.email,
    super.contact,
    super.schedules,
    super.isAuthenticated,
    List<User>? clients,
  }) : _clients = clients ?? [];

  List<User> get clients => _clients;

  set clients(List<User> value) => _clients = value;

  void addClient(User client) {
    _clients.add(client);
  }

  void removeClient(User client) {
    _clients.remove(client);
  }
}
