class Workout {
  final int id;
  final int userId;
  final String name;
  final int sets;
  final int defaultReps;
  final int defaultWeight;

  Workout({
    required this.id,
    required this.userId,
    required this.name,
    required this.sets,
    required this.defaultReps,
    required this.defaultWeight,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'sets': sets,
      'default_reps': defaultReps,
      'default_weight': defaultWeight,
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      sets: map['sets'],
      defaultReps: map['default_reps'],
      defaultWeight: map['default_weight'],
    );
  }
}
