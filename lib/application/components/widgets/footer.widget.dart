
import 'package:FitApp/application/components/trainer/pages/addWorkoutPage.component.dart';
import 'package:FitApp/application/components/trainer/pages/homePage.component.dart';
import 'package:FitApp/application/components/trainer/pages/searchPage.component.dart';
import 'package:FitApp/application/components/trainer/pages/userPage.component.dart';
import 'package:FitApp/application/components/trainer/pages/workoutSheetPage.component.dart';
import 'package:FitApp/application/components/user/pages/homePage.component.dart';
import 'package:FitApp/application/components/user/pages/schedulerPage.component.dart';
import 'package:FitApp/application/components/user/pages/workoutSchedulerPage.component.dart';
import 'package:FitApp/application/entities/user.type.dart';
import 'package:flutter/material.dart';

class FooterWidget extends StatefulWidget {
  final int selectedIndex;
  final UserType userType;

  const FooterWidget(
      {super.key, this.selectedIndex = 0, this.userType = UserType.user});

  @override
  State<FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget> {
  late int _selectedIndex;
  late List<Widget> _accessiblePages;
  late List<BottomNavigationBarItem> _accessibleItems;

  final List<Widget> _userPages = [
    const UserHomePage(),
    const SchedulerPage(),
    const WorkoutSchedulerPage(),
  ];

  final List<BottomNavigationBarItem> _userItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Agenda'),
    BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Treinos'),
  ];

  final List<Widget> _trainerPages = [
    const TrainerHomePage(),
    const SearchPage(),
    const AddWorkoutPage(),
    const WorkoutSheetPage(),
    UsersPage()
  ];

  final List<BottomNavigationBarItem> _trainerItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
    BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Treinos'),
    BottomNavigationBarItem(icon: Icon(Icons.file_copy), label: 'Fichas'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'usuários'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;

    if (widget.userType == UserType.trainer) {
      _accessiblePages = _trainerPages;
      _accessibleItems = _trainerItems;
    } else {
      _accessiblePages = _userPages;
      _accessibleItems = _userItems;
    }
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _accessiblePages[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: _onItemTapped,
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color.fromARGB(255, 218, 211, 211),
      selectedItemColor: const Color.fromARGB(255, 4, 91, 7),
      unselectedItemColor: Colors.black,
      items: _accessibleItems,
    );
  }
}
