import 'package:get/get.dart';
import 'api_service.dart';
import 'package:intl/intl.dart';

class CalendarService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();
  
  // Get all habit completions for a user
  Future<List<dynamic>> getAllCompletions(int userId) async {
    try {
      final response = await _apiService.get('calendar/${userId}');
      
      if (response['error'] == true) {
        throw Exception(response['message']);
      }
      
      return response['data'];
    } catch (e) {
      throw Exception('Failed to fetch completions: $e');
    }
  }
  
  // Get completions for a specific date
  Future<Map<String, dynamic>> getCompletionsForDate(int userId, DateTime date) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      
      final response = await _apiService.get('calendar/${userId}/${formattedDate}');
      
      if (response['error'] == true) {
        throw Exception(response['message']);
      }
      
      return response['data'];
    } catch (e) {
      throw Exception('Failed to fetch completions for date: $e');
    }
  }
  
  // Get monthly completions overview
  Future<Map<String, dynamic>> getMonthlyCompletions(int userId, int month, int year) async {
    try {
      final response = await _apiService.get('calendar/${userId}/month/${month}/year/${year}');
      
      if (response['error'] == true) {
        throw Exception(response['message']);
      }
      
      return response['data'];
    } catch (e) {
      throw Exception('Failed to fetch monthly completions: $e');
    }
  }
}
