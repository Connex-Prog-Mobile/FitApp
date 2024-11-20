class WorkoutSet {
  final int id;
  final int workoutId;
  final int? weight;
  final int? reps;
  final bool completed;
  final int restTime;

  WorkoutSet({
    required this.id,
    required this.workoutId,
    this.weight,
    this.reps,
    this.completed = false,
    this.restTime = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workout_id': workoutId,
      'weight': weight,
      'reps': reps,
      'completed': completed ? 1 : 0,
      'rest_time': restTime,
    };
  }

  factory WorkoutSet.fromMap(Map<String, dynamic> map) {
    return WorkoutSet(
      id: map['id'],
      workoutId: map['workout_id'],
      weight: map['weight'],
      reps: map['reps'],
      completed: map['completed'] == 1,
      restTime: map['rest_time'],
    );
  }
}
