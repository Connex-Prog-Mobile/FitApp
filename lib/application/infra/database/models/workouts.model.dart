class Workout {
  final int id;
  final String name;
  final int sets;
  final int defaultReps;
  final int defaultWeight;
  List<int?> weight;
  List<int?> reps;
  List<bool> completed;
  List<int> restTimes;

  Workout({
    this.id = 0,
    required this.name,
    required this.sets,
    required this.defaultReps,
    required this.defaultWeight,
  })  : weight = List.filled(sets, defaultWeight),
        reps = List.filled(sets, defaultReps),
        completed = List.filled(sets, false),
        restTimes = List.filled(sets, 0);

  
  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      name: map['name'],
      sets: map['sets'],
      defaultReps: map['default_reps'],
      defaultWeight: map['default_weight'],
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sets': sets,
      'default_reps': defaultReps,
      'default_weight': defaultWeight,
    };
  }
}
