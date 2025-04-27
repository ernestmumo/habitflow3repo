import 'package:flutter/material.dart';

class HabitRecord {
  final String id;
  final String habitId;
  final String habitName;
  final String category;
  final Color categoryColor;
  final DateTime date;
  final bool completed;

  HabitRecord({
    required this.id,
    required this.habitId,
    required this.habitName,
    required this.category,
    required this.categoryColor,
    required this.date,
    required this.completed,
  });
}