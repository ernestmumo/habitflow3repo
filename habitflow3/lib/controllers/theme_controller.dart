import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  final RxBool isDarkMode = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadThemeMode();
  }
  
  // Load saved theme preference
  Future<void> loadThemeMode() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
      changeThemeMode(isDarkMode.value);
    } catch (e) {
      print('Error loading theme: $e');
    }
  }
  
  // Toggle between light and dark mode
  void toggleThemeMode() {
    isDarkMode.value = !isDarkMode.value;
    changeThemeMode(isDarkMode.value);
    saveThemeMode();
  }
  
  // Apply the selected theme
  void changeThemeMode(bool isDark) {
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
  
  // Save theme preference
  Future<void> saveThemeMode() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', isDarkMode.value);
    } catch (e) {
      print('Error saving theme: $e');
    }
  }
}
