import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import '../models/habit.dart';

class DashboardController extends GetxController {
  final RxString greeting = ''.obs;
  final RxInt habitsForToday = 0.obs;
  final RxInt completedHabits = 0.obs;
  final RxDouble completionRate = 0.0.obs;
  final RxList<HabitModel> todaysHabits = <HabitModel>[].obs;
  final RxString motivationQuote = 'Consistency is the key to success!'.obs;

  @override
  void onInit() {
    super.onInit();
    _setGreeting();
    _loadHabits();
    _calculateStats();
  }

  void _setGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting.value = 'Good Morning';
    } else if (hour < 17) {
      greeting.value = 'Good Afternoon';
    } else {
      greeting.value = 'Good Evening';
    }
  }

  void _loadHabits() {
    // This would normally be fetched from a database
    // Using mock data for demonstration
    final categories = [
      {'name': 'Exercise', 'color': Colors.red},
      {'name': 'Reading', 'color': Colors.blue},
      {'name': 'Meditation', 'color': Colors.purple},
      {'name': 'Learning', 'color': Colors.green},
      {'name': 'Hydration', 'color': Colors.cyan},
    ];

    final descriptions = [
      'Stay fit and healthy',
      'Expand your knowledge',
      'Calm your mind',
      'Grow your skills',
      'Stay hydrated throughout the day',
    ];

    final random = math.Random();
    
    List<HabitModel> habits = List.generate(
      5,
      (index) {
        final category = categories[index % categories.length];
        return HabitModel(
          id: 'habit_${index + 1}',
          name: '${category['name']} ${index + 1}',
          description: descriptions[index % descriptions.length],
          category: category['name'] as String,
          categoryColor: category['color'] as Color,
          createdAt: DateTime.now().subtract(Duration(days: random.nextInt(30))),
          streakCount: random.nextInt(10) + 1,
          longestStreak: random.nextInt(20) + 5,
          isDone: random.nextBool(),
        );
      },
    );

    todaysHabits.value = habits;
    habitsForToday.value = habits.length;
  }

  void _calculateStats() {
    completedHabits.value = todaysHabits.where((habit) => habit.isDone.value).length;
    completionRate.value = todaysHabits.isEmpty
        ? 0.0
        : (completedHabits.value / todaysHabits.length) * 100;
  }

  void toggleHabitCompletion(String habitId) {
    final index = todaysHabits.indexWhere((habit) => habit.id == habitId);
    if (index != -1) {
      todaysHabits[index].isDone.value = !todaysHabits[index].isDone.value;
      _calculateStats();
    }
  }

  List<Map<String, dynamic>> getWeeklyData() {
    // Mock data for weekly progress
    final random = math.Random();
    return List.generate(7, (index) {
      final day = DateTime.now().subtract(Duration(days: 6 - index));
      final completed = random.nextInt(5) + 1;
      final total = 5;
      return {
        'day': day,
        'completed': completed,
        'total': total,
        'percentage': (completed / total) * 100,
      };
    });
  }

  void refreshDashboard() {
    _loadHabits();
    _calculateStats();
  }
}
