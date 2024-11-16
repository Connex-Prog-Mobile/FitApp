import 'package:fit_app/application/components/landingPage.component.dart';
import 'package:fit_app/application/infra/@providers/User.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => UserProvider(),
        child: const App(),
      ),
    );

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Login App',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const LandingPage());
  }
}
