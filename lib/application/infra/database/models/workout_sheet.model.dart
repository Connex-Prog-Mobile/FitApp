import 'package:FitApp/application/entities/workout.entity.dart';

class WorkoutSheet {
  final int? id;
  final int userId;
  final String? observations;
  final String? objectives;

  WorkoutSheet({
    required this.userId,
    this.id,
    this.observations,
    this.objectives,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'observations': observations,
      'objectives': objectives,
    };
  }

  factory WorkoutSheet.fromMap(
      Map<String, dynamic> map, List<Workout> workouts) {
    return WorkoutSheet(
      id: map['id'],
      userId: map['user_id'],
      observations: map['observations'],
      objectives: map['objectives'],
    );
  }
}
