import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

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

class CalendarController extends GetxController {
  final Rx<DateTime> focusedDay = DateTime.now().obs;
  final Rx<DateTime> selectedDay = DateTime.now().obs;
  final Rx<CalendarFormat> calendarFormat = CalendarFormat.month.obs;
  final RxMap<DateTime, List<HabitRecord>> habitRecords = <DateTime, List<HabitRecord>>{}.obs;
  final RxList<HabitRecord> selectedDayRecords = <HabitRecord>[].obs;
  final RxString selectedMonthOverview = ''.obs;
  final RxDouble monthlyCompletionRate = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _generateMockData();
    _updateSelectedDayRecords();
    _updateMonthStats();
  }

  void _generateMockData() {
    final random = math.Random();
    final now = DateTime.now();
    
    // Categories with colors for visual distinction
    final categories = [
      {'name': 'Exercise', 'color': Colors.red},
      {'name': 'Reading', 'color': Colors.blue},
      {'name': 'Meditation', 'color': Colors.purple},
      {'name': 'Learning', 'color': Colors.green},
      {'name': 'Hydration', 'color': Colors.cyan},
    ];
    
    // Generate habit names
    final habitNames = [
      'Morning Run',
      'Read 30 Pages',
      'Meditate 10 Minutes',
      'Study Flutter',
      'Drink 2L Water',
      'Evening Yoga',
      'Practice Guitar',
      'Journal Entry',
      'Take Vitamins',
      'Call Family',
    ];

    // Generate mock data for the current month and the previous month
    final Map<DateTime, List<HabitRecord>> tempRecords = {};
    
    for (int i = -40; i <= 10; i++) {
      final day = DateTime(now.year, now.month, now.day).add(Duration(days: i));
      final dayKey = DateTime(day.year, day.month, day.day);
      
      // Generate 3-5 habits per day
      final numberOfHabits = random.nextInt(3) + 3;
      List<HabitRecord> dayRecords = [];
      
      for (int j = 0; j < numberOfHabits; j++) {
        final habitIndex = random.nextInt(habitNames.length);
        final categoryIndex = random.nextInt(categories.length);
        
        dayRecords.add(HabitRecord(
          id: 'record_${dayKey.toString()}_$j',
          habitId: 'habit_$habitIndex',
          habitName: habitNames[habitIndex],
          category: categories[categoryIndex]['name'] as String,
          categoryColor: categories[categoryIndex]['color'] as Color,
          date: dayKey,
          completed: random.nextDouble() > 0.3, // 70% chance of completion
        ));
      }
      
      tempRecords[dayKey] = dayRecords;
    }
    
    habitRecords.value = tempRecords;
  }

  void _updateSelectedDayRecords() {
    final day = DateTime(
      selectedDay.value.year, 
      selectedDay.value.month, 
      selectedDay.value.day
    );
    
    selectedDayRecords.value = habitRecords[day] ?? [];
  }

  void _updateMonthStats() {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    
    int totalHabits = 0;
    int completedHabits = 0;
    
    habitRecords.forEach((date, records) {
      if (date.year == currentMonth.year && date.month == currentMonth.month) {
        totalHabits += records.length;
        completedHabits += records.where((record) => record.completed).length;
      }
    });
    
    // Calculate completion rate
    monthlyCompletionRate.value = totalHabits > 0 
        ? (completedHabits / totalHabits) * 100 
        : 0.0;
    
    // Create month overview string
    selectedMonthOverview.value = 
        'Completed $completedHabits out of $totalHabits habits in ${DateFormat('MMMM').format(currentMonth)}';
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    this.selectedDay.value = selectedDay;
    this.focusedDay.value = focusedDay;
    _updateSelectedDayRecords();
  }

  void onFormatChanged(CalendarFormat format) {
    calendarFormat.value = format;
  }

  void onPageChanged(DateTime focusedDay) {
    this.focusedDay.value = focusedDay;
  }

  List<HabitRecord> getRecordsForDay(DateTime day) {
    final dayKey = DateTime(day.year, day.month, day.day);
    return habitRecords[dayKey] ?? [];
  }

  Map<String, dynamic> getDayStatistics(DateTime day) {
    final records = getRecordsForDay(day);
    final totalHabits = records.length;
    final completedHabits = records.where((record) => record.completed).length;
    final completionRate = totalHabits > 0 ? (completedHabits / totalHabits) * 100 : 0.0;
    
    return {
      'date': day,
      'totalHabits': totalHabits,
      'completedHabits': completedHabits,
      'completionRate': completionRate,
    };
  }

  Color getDayColor(DateTime day) {
    final stats = getDayStatistics(day);
    final completionRate = stats['completionRate'] as double;
    
    if (completionRate >= 80) {
      return Colors.green;
    } else if (completionRate >= 50) {
      return Colors.amber;
    } else if (completionRate > 0) {
      return Colors.red;
    } else {
      return Colors.grey.shade300;
    }
  }

  List<Map<String, dynamic>> getWeeklyData() {
    final now = DateTime.now();
    final endDay = DateTime(now.year, now.month, now.day);
    final startDay = endDay.subtract(const Duration(days: 6));
    
    List<Map<String, dynamic>> weekData = [];
    
    for (int i = 0; i < 7; i++) {
      final day = startDay.add(Duration(days: i));
      weekData.add(getDayStatistics(day));
    }
    
    return weekData;
  }

  void refreshCalendarData() {
    _updateSelectedDayRecords();
    _updateMonthStats();
    update();
  }
}
