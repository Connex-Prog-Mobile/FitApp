import 'package:flutter/material.dart';

class Schedule {
  int? id;
  final int userId;
  final DateTime date;
  final TimeOfDay time;
  final String? description;

  Schedule({
    this.id,
    required this.userId,
    required this.date,
    required this.time,
    this.description,
  });

  String get formattedDateTime {
    final dateStr =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    final timeStr =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    return '$dateStr $timeStr';
  }

  String formattedDate(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/'
        '${dateTime.month.toString().padLeft(2, '0')}/'
        '${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      id: map['id'],
      userId: map['user_id'],
      date: DateTime.parse(map['date']),
      time: TimeOfDay(
        hour: int.parse(map['time'].split(':')[0]),
        minute: int.parse(map['time'].split(':')[1]),
      ),
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String(),
      'time': '${time.hour}:${time.minute}',
      'description': description,
    };
  }

  @override
  String toString() {
    return 'Schedule(date: $date, time: $time, description: "$description")';
  }

  bool isSameSchedule(Schedule other) {
    return date == other.date &&
        time.hour == other.time.hour &&
        time.minute == other.time.minute;
  }
}
