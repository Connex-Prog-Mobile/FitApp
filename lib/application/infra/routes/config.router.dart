import 'package:FitApp/application/components/login/landingPage.component.dart';
import 'package:FitApp/application/components/register/registerPage.component.dart';
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

final Map<UserType, List<String>> accessibleRoutes = {
  UserType.user: ['/userHome','/register', '/scheduler', '/workoutScheduler'],
  UserType.trainer: ['/trainerHome', '/search', '/users', '/addWorkout', '/workoutSheet'],
};

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const LandingPage(),
  '/userHome': (context) => const UserHomePage(),
  '/register': (context) => const RegisterPage(),
  '/scheduler': (context) => const SchedulerPage(),
  '/workoutScheduler': (context) => const WorkoutSchedulerPage(),
  // '/trainerHome': (context) => const TrainerHomePage(),
  '/search': (context) => const SearchPage(),
  '/users': (context) => UsersPage(),
  '/addWorkout': (context) => const AddWorkoutPage(),
  '/workoutSheet': (context) => const WorkoutSheetPage()
};
