import 'package:fit_app/application/components/pages/home/landingPage.component.dart';
import 'package:fit_app/application/entities/user.entity.dart';
import 'package:fit_app/application/infra/@providers/User.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String widgetTitle;
  final bool centralize;

  const DefaultAppBar(this.widgetTitle, {super.key, this.centralize = true});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final User? activeUser = userProvider.activeUser;

    return AppBar(
      title: Text(
        widgetTitle,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),
      ),
      backgroundColor: Colors.green,
      centerTitle: centralize,
      automaticallyImplyLeading: false,
      actions: [
        if (activeUser?.isAuthenticated == true)
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              userProvider.logout();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LandingPage()),
              );
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
