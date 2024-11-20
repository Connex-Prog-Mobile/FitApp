import 'package:fit_app/application/entities/user.entity.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class UsersRepository extends ChangeNotifier {
  late Database db;
  List<User> _users = [];
}