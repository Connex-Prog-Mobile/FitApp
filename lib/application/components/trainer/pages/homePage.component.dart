
import 'package:FitApp/application/components/widgets/defaultAppBar.widget.dart';
import 'package:FitApp/application/components/widgets/footer.widget.dart';
import 'package:FitApp/application/entities/user.entity.dart';
import 'package:FitApp/application/infra/@providers/User.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrainerHomePage extends StatefulWidget {
  const TrainerHomePage({super.key});

  @override
  TrainerHomePageState createState() => TrainerHomePageState();
}

class TrainerHomePageState extends State<TrainerHomePage> {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    final User? activeUser = userProvider.activeUser;

    return Scaffold(
      appBar: const DefaultAppBar('Trainer Home'),
      body: const Center(
        child: Text(
          'Em Desenvolvimento',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      bottomNavigationBar: FooterWidget(selectedIndex: 0, userType: userProvider.userType),
    );
  }
}
