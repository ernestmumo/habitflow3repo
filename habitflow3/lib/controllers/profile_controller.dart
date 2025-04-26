import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import '../models/activity_log.dart';
import '../models/achievements.dart';

class ProfileController extends GetxController {
  final RxString name = 'User Name'.obs;
  final RxString email = 'user@example.com'.obs;
  final RxString bio = 'Habit enthusiast on a journey to greatness'.obs;
  final RxString profileImageUrl = ''.obs;
  
  // Statistics
  final RxInt totalHabits = 0.obs;
  final RxInt currentStreak = 0.obs;
  final RxInt longestStreak = 0.obs;
  final RxDouble weeklyCompletionRate = 0.0.obs;
  final RxDouble monthlyCompletionRate = 0.0.obs;
  
  // Achievements
  final RxList<Achievement> achievements = <Achievement>[].obs;
  
  // Activity logs
  final RxList<ActivityLog> activityLogs = <ActivityLog>[].obs;
  
  // Settings
  final RxBool darkMode = false.obs;
  final RxBool notificationsEnabled = true.obs;
  final RxString reminderTime = '08:00 AM'.obs;
  
  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
    _loadStatistics();
    _loadAchievements();
    _loadActivityLogs();
  }
  
  void _loadUserProfile() {
    // This would normally be loaded from user database
    // Using mock data for demonstration
    name.value = 'John Doe';
    email.value = 'john.doe@example.com';
    bio.value = 'Committed to building positive habits every day';
    profileImageUrl.value = ''; // Would be a URL to profile picture
  }
  
  void _loadStatistics() {
    // Using mock data for demonstration
    final random = math.Random();
    
    totalHabits.value = random.nextInt(10) + 5;
    currentStreak.value = random.nextInt(15) + 1;
    longestStreak.value = random.nextInt(30) + 15;
    weeklyCompletionRate.value = 60 + random.nextInt(40).toDouble();
    monthlyCompletionRate.value = 50 + random.nextInt(50).toDouble();
  }
  
  void _loadAchievements() {
    // Using mock data for demonstration
    final now = DateTime.now();
    final random = math.Random();
    
    final mockAchievements = [
      Achievement(
        id: '1',
        title: '7-Day Streak',
        description: 'Maintained habits for 7 consecutive days',
        icon: Icons.local_fire_department,
        earnedAt: now.subtract(Duration(days: random.nextInt(30))),
      ),
      Achievement(
        id: '2',
        title: 'Early Bird',
        description: 'Completed morning habits for 5 consecutive days',
        icon: Icons.wb_sunny,
        earnedAt: now.subtract(Duration(days: random.nextInt(20))),
      ),
      Achievement(
        id: '3',
        title: 'Habit Master',
        description: 'Reached 100% completion rate for a week',
        icon: Icons.military_tech,
        earnedAt: now.subtract(Duration(days: random.nextInt(15))),
      ),
      Achievement(
        id: '4',
        title: 'Milestone: 5 Habits',
        description: 'Created and maintained 5 different habits',
        icon: Icons.emoji_events,
        earnedAt: now.subtract(Duration(days: random.nextInt(10))),
      ),
      Achievement(
        id: '5',
        title: 'Consistency Champion',
        description: 'Completed all habits for 14 consecutive days',
        icon: Icons.stars,
        earnedAt: now.subtract(Duration(days: random.nextInt(5))),
      ),
    ];
    
    achievements.value = mockAchievements;
  }
  
  void _loadActivityLogs() {
    // Using mock data for demonstration
    final now = DateTime.now();
    
    final activities = [
      ActivityLog(
        id: '1',
        description: 'Completed "Morning Meditation" habit',
        timestamp: now.subtract(Duration(hours: 2)),
        icon: Icons.spa,
      ),
      ActivityLog(
        id: '2',
        description: 'Added a new habit: "Evening Reading"',
        timestamp: now.subtract(Duration(days: 1, hours: 5)),
        icon: Icons.add_circle,
      ),
      ActivityLog(
        id: '3',
        description: 'Achieved a 7-day streak!',
        timestamp: now.subtract(Duration(days: 2)),
        icon: Icons.local_fire_department,
      ),
      ActivityLog(
        id: '4',
        description: 'Updated profile information',
        timestamp: now.subtract(Duration(days: 3, hours: 7)),
        icon: Icons.person,
      ),
      ActivityLog(
        id: '5',
        description: 'Completed all habits for the day',
        timestamp: now.subtract(Duration(days: 4)),
        icon: Icons.done_all,
      ),
    ];
    
    activityLogs.value = activities;
  }
  
  void updateProfile({
    String? name,
    String? email,
    String? bio,
    String? profileImageUrl,
  }) {
    if (name != null) this.name.value = name;
    if (email != null) this.email.value = email;
    if (bio != null) this.bio.value = bio;
    if (profileImageUrl != null) this.profileImageUrl.value = profileImageUrl;
    
    // Add activity log
    activityLogs.insert(
      0,
      ActivityLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        description: 'Updated profile information',
        timestamp: DateTime.now(),
        icon: Icons.person,
      ),
    );
    
    update();
  }
  
  void toggleDarkMode() {
    darkMode.value = !darkMode.value;
    Get.changeThemeMode(darkMode.value ? ThemeMode.dark : ThemeMode.light);
    update();
  }
  
  void toggleNotifications() {
    notificationsEnabled.value = !notificationsEnabled.value;
    update();
  }
  
  void setReminderTime(String time) {
    reminderTime.value = time;
    update();
  }
  
  List<Map<String, dynamic>> getWeeklyActivityData() {
    // Mock data for weekly activity chart
    final random = math.Random();
    final now = DateTime.now();
    
    return List.generate(7, (index) {
      final day = now.subtract(Duration(days: 6 - index));
      return {
        'day': day,
        'count': random.nextInt(10) + 1,
      };
    });
  }
  
  void logout() {
    // This would normally handle the logout logic
    // For now, just navigate to login screen
    Get.offAllNamed('/login');
  }
}
