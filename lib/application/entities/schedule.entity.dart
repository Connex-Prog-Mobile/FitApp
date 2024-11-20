import 'package:flutter/material.dart';

class Schedule {
  final DateTime date;
  final TimeOfDay time;
  final String description;

  Schedule({
    required this.date,
    required this.time,
    this.description = '',
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
