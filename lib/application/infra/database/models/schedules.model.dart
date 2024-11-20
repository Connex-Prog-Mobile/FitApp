class Schedule {
  final int id;
  final int userId;
  final String date;
  final String time;
  final String? description;

  Schedule({
    required this.id,
    required this.userId,
    required this.date,
    required this.time,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'date': date,
      'time': time,
      'description': description,
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      id: map['id'],
      userId: map['user_id'],
      date: map['date'],
      time: map['time'],
      description: map['description'],
    );
  }
}
