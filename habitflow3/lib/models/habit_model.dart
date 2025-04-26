import 'package:get/get.dart';
import 'package:habitflow/models/habit_category.dart';

class HabitModel {
  final String id;
  final String name;
  final String description;
  final HabitCategory category;
  final DateTime createdAt;
  final Rx<int> streakCount;
  final Rx<int> longestStreak;
  final RxBool isPinned;
  final RxBool isDone;
  final List<DateTime> completedDates;
  final String reminder;

  HabitModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.createdAt,
    required int streakCount,
    required int longestStreak,
    required bool isPinned,
    required bool isDone,
    required this.completedDates,
    required this.reminder,
  })  : streakCount = streakCount.obs,
        longestStreak = longestStreak.obs,
        isPinned = isPinned.obs,
        isDone = isDone.obs;
}