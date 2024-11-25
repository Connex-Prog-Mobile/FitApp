import 'package:FitApp/application/components/widgets/defaultAppBar.widget.dart';
import 'package:FitApp/application/components/widgets/footer.widget.dart';
import 'package:FitApp/application/entities/user.entity.dart';
import 'package:FitApp/application/infra/@providers/User.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  List<User> userRegisteredList = [];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  bool _isPersonalTrainer = false;

  String _generateUserCode() {
    DateTime now = DateTime.now();
    String formattedDate = "${now.year}${now.month.toString().padLeft(2, '0')}";
    return "$formattedDate${now.millisecondsSinceEpoch % 1000}";
  }

  void _cadastrar() async {
    final UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    if (_formKey.currentState?.validate() ?? false) {
      String name = _nameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;
      String confirmPassword = _confirmPasswordController.text;
      String contact = _contactController.text;
      double? height = double.tryParse(_heightController.text);
      double? weight = double.tryParse(_weightController.text);

      double? imc;
      if (height != null && weight != null && height > 0) {
        imc = weight / (height * height);
      } else {
        imc = null;
      }

      String code = _generateUserCode();

      bool userExists = await userProvider.checkIfUserExists(code, email);
      if (userExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Usuário já cadastrado com esse código ou e-mail.')),
        );
        return;
      }

      if (password == confirmPassword) {
        Map<String, dynamic> user = {
          'code': code,
          'password': password,
          'name': name,
          'email': email,
          'contact': contact,
          'height': height ?? 0.0,
          'weight': weight ?? 0.0,
          'imc': imc ?? 0.0,
          'is_authenticated': 0,
          'is_personal_trainer': _isPersonalTrainer ? 1 : 0,
        };

        try {
          await userProvider.addUserToDatabase(user);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Cadastro realizado com sucesso! Matrícula: $code')),
          );

          Navigator.pop(context);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Erro ao cadastrar o usuário. Tente novamente.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Confirmação de senha inválida. As senhas precisam ser iguais.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final User? activeUser = userProvider.activeUser;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const DefaultAppBar('Cadastro de Usuário'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    labelStyle: TextStyle(color: Colors.green),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu nome';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    labelStyle: TextStyle(color: Colors.green),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu e-mail';
                    }
                    if (!RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                        .hasMatch(value)) {
                      return 'Por favor, insira um e-mail válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    labelStyle: TextStyle(color: Colors.green),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirme sua senha',
                    labelStyle: TextStyle(color: Colors.green),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, confirme sua senha';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contato',
                    labelStyle: TextStyle(color: Colors.green),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu contato';
                    }

                    if (!RegExp(r'^\s*(?:\(\d{2}\)|\d{2})\s*\d{5}-?\d{4}\s*$')
                        .hasMatch(value)) {
                      return 'Por favor, insira um número válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  title: const Text('Sou Personal Trainer?'),
                  value: _isPersonalTrainer,
                  onChanged: (bool? value) {
                    setState(() {
                      _isPersonalTrainer = value ?? false;
                    });
                  },
                  activeColor: Colors.green,
                ),
                const SizedBox(height: 16),
                Visibility(
                  visible: !_isPersonalTrainer,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _heightController,
                        decoration: const InputDecoration(
                          labelText: 'Altura (em metros)',
                          labelStyle: TextStyle(color: Colors.green),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                        validator: (value) {
                          if (!_isPersonalTrainer &&
                              (value == null || value.isEmpty)) {
                            return 'Por favor, insira sua altura';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _weightController,
                        decoration: const InputDecoration(
                          labelText: 'Peso (em kg)',
                          labelStyle: TextStyle(color: Colors.green),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                        validator: (value) {
                          if (!_isPersonalTrainer &&
                              (value == null || value.isEmpty)) {
                            return 'Por favor, insira seu peso';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _cadastrar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text(
                      'Cadastrar',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: (activeUser?.isAuthenticated ?? false)
          ? FooterWidget(
              selectedIndex: 1,
              userType: userProvider.userType,
            )
          : const SizedBox.shrink(),
    );
  }
}
