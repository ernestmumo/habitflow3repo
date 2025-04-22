import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class HabitCategory {
  final String name;
  final Color color;
  final IconData icon;

  HabitCategory({
    required this.name,
    required this.color,
    required this.icon,
  });
}

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

class HabitsController extends GetxController {
  final RxList<HabitModel> habits = <HabitModel>[].obs;
  final RxList<HabitModel> filteredHabits = <HabitModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString filterType = 'All'.obs;
  final RxString sortType = 'Default'.obs;
  
  final RxList<HabitCategory> categories = <HabitCategory>[
    HabitCategory(name: 'Exercise', color: Colors.red, icon: Icons.fitness_center),
    HabitCategory(name: 'Reading', color: Colors.blue, icon: Icons.menu_book),
    HabitCategory(name: 'Meditation', color: Colors.purple, icon: Icons.spa),
    HabitCategory(name: 'Learning', color: Colors.green, icon: Icons.school),
    HabitCategory(name: 'Hydration', color: Colors.cyan, icon: Icons.water_drop),
  ].obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadHabits();
    
    // Set up reactions to changes in filters or search
    ever(searchQuery, (_) => _filterAndSortHabits());
    ever(filterType, (_) => _filterAndSortHabits());
    ever(sortType, (_) => _filterAndSortHabits());
  }

  void _loadHabits() {
    // Mock data for demonstration
    final random = math.Random();
    
    List<HabitModel> mockHabits = List.generate(
      10,
      (index) {
        final categoryIndex = random.nextInt(categories.length);
        return HabitModel(
          id: 'habit_${index + 1}',
          name: '${categories[categoryIndex].name} ${index + 1}',
          description: 'Description for habit ${index + 1}',
          category: categories[categoryIndex],
          createdAt: DateTime.now().subtract(Duration(days: random.nextInt(30))),
          streakCount: random.nextInt(10),
          longestStreak: random.nextInt(20) + 5,
          isPinned: random.nextBool(),
          isDone: random.nextBool(),
          completedDates: List.generate(
            random.nextInt(20),
            (i) => DateTime.now().subtract(Duration(days: random.nextInt(30))),
          ),
          reminder: '${random.nextInt(12) + 1}:${random.nextInt(6)}0 ${random.nextBool() ? 'AM' : 'PM'}',
        );
      },
    );
    
    habits.value = mockHabits;
    _filterAndSortHabits();
  }

  void _filterAndSortHabits() {
    // Apply search filter
    var result = searchQuery.isEmpty
        ? habits.toList()
        : habits
            .where((habit) =>
                habit.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                habit.description.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

    // Apply category filter
    if (filterType.value != 'All') {
      result = result
          .where((habit) => habit.category.name == filterType.value)
          .toList();
    }

    // Apply sorting
    switch (sortType.value) {
      case 'Name':
        result.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Newest':
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'Oldest':
        result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'Streak':
        result.sort((a, b) => b.streakCount.value.compareTo(a.streakCount.value));
        break;
      default:
        // Default sorting: Pinned first, then by name
        result.sort((a, b) {
          if (a.isPinned.value && !b.isPinned.value) return -1;
          if (!a.isPinned.value && b.isPinned.value) return 1;
          return a.name.compareTo(b.name);
        });
    }

    filteredHabits.value = result;
  }

  void toggleHabitCompletion(String habitId) {
    final index = habits.indexWhere((habit) => habit.id == habitId);
    if (index != -1) {
      final habit = habits[index];
      final newIsDone = !habit.isDone.value;
      habit.isDone.value = newIsDone;
      
      // Update streak
      if (newIsDone) {
        habit.streakCount.value += 1;
        if (habit.streakCount.value > habit.longestStreak.value) {
          habit.longestStreak.value = habit.streakCount.value;
        }
        
        // Add today to completed dates
        final today = DateTime.now();
        final formattedToday = DateTime(today.year, today.month, today.day);
        if (!habit.completedDates.any((date) => 
            date.year == formattedToday.year && 
            date.month == formattedToday.month && 
            date.day == formattedToday.day)) {
          habit.completedDates.add(formattedToday);
        }
      } else {
        habit.streakCount.value = math.max(0, habit.streakCount.value - 1);
        
        // Remove today from completed dates
        final today = DateTime.now();
        habit.completedDates.removeWhere((date) => 
            date.year == today.year && 
            date.month == today.month && 
            date.day == today.day);
      }
      
      // Update filtered habits
      _filterAndSortHabits();
    }
  }

  void togglePinned(String habitId) {
    final index = habits.indexWhere((habit) => habit.id == habitId);
    if (index != -1) {
      habits[index].isPinned.value = !habits[index].isPinned.value;
      _filterAndSortHabits();
    }
  }

  void addHabit(HabitModel habit) {
    habits.add(habit);
    _filterAndSortHabits();
  }

  void updateHabit(HabitModel updatedHabit) {
    final index = habits.indexWhere((habit) => habit.id == updatedHabit.id);
    if (index != -1) {
      habits[index] = updatedHabit;
      _filterAndSortHabits();
    }
  }

  void deleteHabit(String habitId) {
    habits.removeWhere((habit) => habit.id == habitId);
    _filterAndSortHabits();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setFilterType(String type) {
    filterType.value = type;
  }

  void setSortType(String type) {
    sortType.value = type;
  }
}
