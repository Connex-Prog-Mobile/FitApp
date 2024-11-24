
import 'package:FitApp/application/components/register/registerPage.component.dart';
import 'package:FitApp/application/components/widgets/defaultAppBar.widget.dart';
import 'package:FitApp/application/components/widgets/footer.widget.dart';
import 'package:FitApp/application/entities/user.entity.dart';
import 'package:FitApp/application/entities/user.type.dart';
import 'package:FitApp/application/infra/database/databaseHelper.dart';
import 'package:FitApp/application/infra/database/models/workout_sheet.model.dart';
import 'package:FitApp/application/infra/database/models/workouts.model.dart';
import 'package:FitApp/application/infra/database/repositories/user.repository.dart';
import 'package:FitApp/application/infra/database/repositories/workout.repository.dart';
import 'package:FitApp/application/infra/database/repositories/workout_sheet.repository.dart';
import 'package:FitApp/application/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class WorkoutSheetPage extends StatefulWidget {
  const WorkoutSheetPage({Key? key}) : super(key: key);

  @override
  _WorkoutSheetPageState createState() => _WorkoutSheetPageState();
}

class _WorkoutSheetPageState extends State<WorkoutSheetPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _sheetController = TextEditingController();
  final TextEditingController _objectiveController = TextEditingController();
  final TextEditingController _observationController = TextEditingController();

  late Database db;
  late WorkoutRepository workoutRepository;
  List<dynamic> _searchResults = [];
  User? _selectedUser;

  List<Workout> _selectedExercises = [];
  List<Workout> workoutsList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterUsers);
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    db = await DatabaseHelper().database;
    workoutRepository = WorkoutRepository(db);
    await _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    List<Workout> workouts = await workoutRepository.getAllMappedWorkouts();
    setState(() {
      workoutsList = workouts;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterUsers);
    _searchController.dispose();
    super.dispose();
  }

  void _filterUsers() async {
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      final userRepository = UserRepository();
      final results = await userRepository.searchUsersByName(query);

      setState(() {
        _searchResults = results;
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  void _selectUser(User user) {
    setState(() {
      _selectedUser = user;
      _searchResults = [];
      _searchController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Usuário ${user.name} selecionado.')),
    );
  }

  void _openExerciseSelectionModal() async {
    final List<Workout>? selected = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return _ExerciseSelectionDialog(
          exercises: workoutsList,
          selectedExercises: _selectedExercises,
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedExercises = selected;
      });
    }
  }

  void _cadastrar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
  }

  Future<void> _sheetRegistration() async {
    if (_selectedUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, selecione um usuário!')),
      );
      return;
    }

    final workoutSheet = WorkoutSheet(
      userId: _selectedUser!.id,
      observations: _observationController.text,
      objectives: _objectiveController.text,
    );

    try {
      final db = await DatabaseHelper().database;
      WorkoutSheetRepository workoutSheetRepository =
          WorkoutSheetRepository(db);

      int sheetId =
          await workoutSheetRepository.insertWorkoutSheet(workoutSheet.toMap());

      for (var workout in _selectedExercises) {
        await db.execute('''
        INSERT INTO workout_sheet_workouts (workout_sheet_id, workout_id)
        VALUES ($sheetId, ${workout.id})
      ''');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ficha cadastrada com sucesso!')),
      );

      navigateTo(context, '/trainerHome');

    } catch (e) {
      print("####### $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar a ficha!')),
      );
    }
  }

  void _searchUser(String query) async {
    final results =
        await db.query('users', where: 'name LIKE ?', whereArgs: ['%$query%']);
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar('Ficha de Cadastro'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Pesquisar por nome',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _searchUser,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: _cadastrar,
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (_selectedUser != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      child: Text(_selectedUser!.name[0].toUpperCase()),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _selectedUser!.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _selectedUser = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
            if (_searchResults.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final user = _searchResults[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(user['name'][0].toUpperCase()),
                      ),
                      title: Text(user['name']),
                      subtitle: Text(user['email']),
                      onTap: () => _selectUser(User.fromMap(user)),
                    );
                  },
                ),
              ),
            GestureDetector(
              onTap: _openExerciseSelectionModal,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 245, 242, 242),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 200, 198, 198)
                          .withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedExercises.isEmpty
                          ? 'Escolha os exercícios'
                          : _selectedExercises
                              .map((exercise) => exercise.name)
                              .join(', '),
                      style: TextStyle(
                        color: _selectedExercises.isEmpty
                            ? Colors.grey
                            : Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _sheetController,
              decoration: const InputDecoration(
                labelText: 'Nome da ficha',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _objectiveController,
              decoration: const InputDecoration(
                labelText: 'Objetivo',
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _observationController,
              decoration: const InputDecoration(
                labelText: 'Observação',
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _sheetRegistration,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
      bottomNavigationBar:
          const FooterWidget(selectedIndex: 3, userType: UserType.trainer),
    );
  }
}

class _ExerciseSelectionDialog extends StatefulWidget {
  final List<Workout> exercises;
  final List<Workout> selectedExercises;

  const _ExerciseSelectionDialog({
    required this.exercises,
    required this.selectedExercises,
  });

  @override
  __ExerciseSelectionDialogState createState() =>
      __ExerciseSelectionDialogState();
}

class __ExerciseSelectionDialogState extends State<_ExerciseSelectionDialog> {
  late List<Workout> _selectedExercises;

  @override
  void initState() {
    super.initState();
    _selectedExercises = List.from(widget.selectedExercises);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Selecione os Exercícios'),
      content: SingleChildScrollView(
        child: Column(
          children: widget.exercises.map((exercise) {
            return CheckboxListTile(
              title: Text(exercise.name),
              value: _selectedExercises.contains(exercise),
              onChanged: (bool? selected) {
                setState(() {
                  if (selected == true) {
                    _selectedExercises.add(exercise);
                  } else {
                    _selectedExercises.remove(exercise);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedExercises);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
