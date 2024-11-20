class WorkoutSheet {
  final int id;
  final int userId;
  final String exercises;
  final String? observations;
  final String? objectives;

  WorkoutSheet({
    required this.id,
    required this.userId,
    required this.exercises,
    this.observations,
    this.objectives,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'exercises': exercises,
      'observations': observations,
      'objectives': objectives,
    };
  }

  factory WorkoutSheet.fromMap(Map<String, dynamic> map) {
    return WorkoutSheet(
      id: map['id'],
      userId: map['user_id'],
      exercises: map['exercises'],
      observations: map['observations'],
      objectives: map['objectives'],
    );
  }
}
