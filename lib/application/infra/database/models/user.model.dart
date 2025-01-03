class User {
  final int id;
  final String code;
  final String password;
  final String name;
  final String email;
  double? height;
  double? weight;
  double? imc;
  final String? contact;
  final bool isAuthenticated;
  final bool isPersonalTrainer;

  User({
    required this.id,
    required this.code,
    required this.password,
    required this.name,
    required this.email,
    this.contact,
    this.height,
    this.weight,
    this.imc,
    this.isAuthenticated = false,
    this.isPersonalTrainer = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'password': password,
      'name': name,
      'email': email,
      'height': height,
      'weight': weight,
      'imc': imc,
      'contact': contact,
      'is_authenticated': isAuthenticated ? 1 : 0,
      'is_personal_trainer': isPersonalTrainer ? 1 : 0,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      code: map['code'],
      password: map['password'],
      name: map['name'],
      email: map['email'],
      height: map['height'],
      weight: map['weight'],
      imc: map['imc'],
      contact: map['contact'],
      isAuthenticated: map['is_authenticated'] == 1,
      isPersonalTrainer: map['is_personal_trainer'] == 1,
    );
  }
}
