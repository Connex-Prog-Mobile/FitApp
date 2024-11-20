import 'package:fit_app/application/components/pages/workout/workoutSchedulerPage.component.dart';
import 'package:fit_app/application/components/pages/home/homePage.component.dart';
import 'package:fit_app/application/components/pages/register/registerPage.component.dart';
import 'package:fit_app/application/components/pages/scheduler/schedulerPage.component.dart';
import 'package:fit_app/application/components/pages/search/searchPage.component.dart';
import 'package:flutter/material.dart';

class FooterWidget extends StatefulWidget {
  int selectedIndex;
  FooterWidget({super.key, this.selectedIndex = 0});

  @override
  State<FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget> {
  late int _selectedIndex;

  final List<Widget> _pages = [
    const HomePage(),
    const RegisterPage(),
    const WorkoutSchedulerPage(),
    const SchedulerPage(),
    const SearchPage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: _onItemTapped,
      currentIndex: _selectedIndex ?? 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color.fromARGB(255, 218, 211, 211),
      selectedItemColor: const Color.fromARGB(255, 4, 91, 7),
      unselectedItemColor: Colors.black,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.app_registration),
          label: 'Registrar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Exercícios',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Agenda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Buscar',
        )
      ],
    );
  }
}

        // BottomNavigationBarItem(
        //   icon: Icon(Icons.assignment_add),
        //   label: 'Fichas',
        // ),