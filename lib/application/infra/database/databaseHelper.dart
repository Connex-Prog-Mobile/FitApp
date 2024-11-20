import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    print('caminho do bando no cell: $dbPath');
    final path = join(dbPath, 'fit_app.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) async{
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            code TEXT NOT NULL,
            password TEXT NOT NULL,
            name TEXT NOT NULL,
            email TEXT NOT NULL,
            contact TEXT,
            is_authenticated INTEGER DEFAULT 0,
            is_personal_trainer INTEGER DEFAULT 0
          )''');

        await db.execute('''CREATE TABLE schedules (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            date TEXT NOT NULL,
            time TEXT NOT NULL,
            description TEXT,
            FOREIGN KEY (user_id) REFERENCES users (id)
          )''');

        await db.execute('''CREATE TABLE workouts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            name TEXT NOT NULL,
            sets INTEGER NOT NULL,
            default_reps INTEGER NOT NULL,
            default_weight INTEGER NOT NULL,
            FOREIGN KEY (user_id) REFERENCES users (id)
          )''');

        await db.execute('''CREATE TABLE workout_sets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            workout_id INTEGER NOT NULL,
            weight INTEGER,
            reps INTEGER,
            completed INTEGER DEFAULT 0,
            rest_time INTEGER DEFAULT 0,
            FOREIGN KEY (workout_id) REFERENCES workouts (id)
          )''');

        await db.execute('''CREATE TABLE workout_sheets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            exercises TEXT NOT NULL,
            observations TEXT,
            objectives TEXT,
            FOREIGN KEY (user_id) REFERENCES users (id)
          )''');
      },
    );
  }
}
