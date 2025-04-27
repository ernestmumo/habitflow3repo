import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/navigation_controller.dart';
import 'dashboard_screen.dart';
import 'habits_screen.dart';
import 'calendar_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final NavigationController navigationController = Get.put(NavigationController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Obx(() {
        switch (navigationController.selectedIndex.value) {
          case 0:
            return DashboardScreen();
          case 1:
            return HabitsScreen();
          case 2:
            return CalendarScreen();
          case 3:
            return ProfileScreen();
          default:
            return DashboardScreen();
        }
      }),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
        currentIndex: navigationController.selectedIndex.value,
        onTap: navigationController.changePage,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        selectedItemColor: Colors.blue.shade600,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Habits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      )),
    );
  }
}
