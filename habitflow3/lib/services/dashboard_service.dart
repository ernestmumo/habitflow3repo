import 'package:get/get.dart';
import 'api_service.dart';
//import 'habits_service.dart';
import 'package:intl/intl.dart';

class DashboardService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();
  // final HabitsService _habitsService = Get.find<HabitsService>();
  
  // Get habits for today
  Future<List<dynamic>> getTodaysHabits(int userId) async {
    try {
      // We'll get the habits directly from the calendar endpoint
      // which already includes completion status
      
      // Get today's date
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      
      // Get completions for today
      final completions = await _apiService.get('calendar/${userId}/${today}');
      
      if (completions['error'] == true) {
        throw Exception(completions['message']);
      }
      
      return completions['data'];
    } catch (e) {
      throw Exception('Failed to fetch today\'s habits: $e');
    }
  }
  
  // Get weekly completion data
  Future<List<Map<String, dynamic>>> getWeeklyData(int userId) async {
    try {
      final result = <Map<String, dynamic>>[];
      final now = DateTime.now();
      
      // Get last 7 days of data
      for (int i = 6; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final dateStr = DateFormat('yyyy-MM-dd').format(date);
        
        final response = await _apiService.get('calendar/${userId}/${dateStr}');
        
        if (response['error'] == true) {
          throw Exception(response['message']);
        }
        
        final records = response['data'];
        final completed = records.where((record) => record['completed'] == true).length;
        final total = records.length;
        final percentage = total > 0 ? (completed / total) * 100 : 0;
        
        result.add({
          'day': date,
          'completed': completed,
          'total': total,
          'percentage': percentage,
        });
      }
      
      return result;
    } catch (e) {
      throw Exception('Failed to fetch weekly data: $e');
    }
  }
  
  // Calculate today's stats
  Future<Map<String, dynamic>> calculateTodayStats(int userId) async {
    try {
      // Use the dashboard endpoint directly
      final response = await _apiService.get('dashboard/${userId}');
      
      if (response['error'] == true) {
        throw Exception(response['message']);
      }
      
      final data = response['data'];
      return {
        'habitsForToday': data['total_today'] ?? 0,
        'completedHabits': data['completed_today'] ?? 0, 
        'completionRate': data['total_today'] > 0 
          ? (data['completed_today'] / data['total_today']) * 100 
          : 0,
      };
    } catch (e) {
      throw Exception('Failed to calculate today\'s stats: $e');
    }
  }
}
