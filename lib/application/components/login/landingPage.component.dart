import 'package:FitApp/application/components/register/registerPage.component.dart';
import 'package:FitApp/application/entities/user.type.dart';
import 'package:FitApp/application/infra/@providers/User.provider.dart';
import 'package:FitApp/application/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  final TextEditingController _userCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: const Color(0xFF38c958),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'lib/application/assets/home/logo.png',
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: 20),
                const Text('Olá, faça seu login ou cadastre-se',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    textAlign: TextAlign.center),
                const SizedBox(height: 30),
                TextField(
                  controller: _userCodeController,
                  decoration: InputDecoration(
                      labelText: 'Matrícula',
                      labelStyle: const TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      labelText: 'Senha',
                      labelStyle: const TextStyle(color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    String userCode = _userCodeController.text;
                    String password = _passwordController.text;
                    final UserProvider userProvider =
                        Provider.of<UserProvider>(context, listen: false);

                    bool userIsValid =
                        await userProvider.validateUser(userCode, password);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          userIsValid
                              ? 'Login realizado com sucesso'
                              : 'Matrícula ou senha inválidas',
                        ),
                        backgroundColor: userIsValid
                            ? const Color.fromARGB(255, 5, 39, 6)
                            : Colors.red,
                      ),
                    );


                    if (userIsValid) {
                      userProvider.activeUser?.isAuthenticated = true;
                      userProvider.userType =
                          userProvider.activeUser!.isPersonalTrainer
                              ? UserType.trainer
                              : UserType.user;
                      
                      _userCodeController.clear();
                      _passwordController.clear();
                      if (userProvider.userType == UserType.trainer) {
                        navigateTo(context, '/trainerHome');
                      } else {
                        navigateTo(context, '/userHome');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('Entrar'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Cadastre-se',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
