import 'package:flutter/material.dart' show Color;
import 'package:get/get.dart';

class HabitModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final Color categoryColor;
  final DateTime createdAt;
  final int streakCount;
  final int longestStreak;
  RxBool isDone;

  HabitModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.categoryColor,
    required this.createdAt,
    required this.streakCount,
    required this.longestStreak,
    required bool isDone,
  }) : isDone = isDone.obs;
}