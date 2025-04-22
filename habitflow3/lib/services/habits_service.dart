import 'package:get/get.dart';
import 'api_service.dart';

class HabitsService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();
  
  // Get all habits for a user
  Future<List<dynamic>> getUserHabits(int userId) async {
    try {
      final response = await _apiService.get('habits/${userId}');
      
      if (response['error'] == true) {
        throw Exception(response['message']);
      }
      
      return response['data'];
    } catch (e) {
      throw Exception('Failed to fetch habits: $e');
    }
  }
  
  // Get a habit by ID
  Future<Map<String, dynamic>> getHabitById(int habitId) async {
    try {
      final response = await _apiService.get('habits/detail/${habitId}');
      
      if (response['error'] == true) {
        throw Exception(response['message']);
      }
      
      return response['data'];
    } catch (e) {
      throw Exception('Failed to fetch habit details: $e');
    }
  }
  
  // Create a new habit
  Future<Map<String, dynamic>> createHabit(Map<String, dynamic> habitData) async {
    try {
      final response = await _apiService.post('habits', habitData);
      
      if (response['error'] == true) {
        throw Exception(response['message']);
      }
      
      return response['data'];
    } catch (e) {
      throw Exception('Failed to create habit: $e');
    }
  }
  
  // Update an existing habit
  Future<Map<String, dynamic>> updateHabit(Map<String, dynamic> habitData) async {
    try {
      final habitId = habitData['id'];
      if (habitId == null) {
        throw Exception('Habit ID is required');
      }
      final response = await _apiService.put('habits/${habitId}', habitData);
      
      if (response['error'] == true) {
        throw Exception(response['message']);
      }
      
      return response['data'];
    } catch (e) {
      throw Exception('Failed to update habit: $e');
    }
  }
  
  // Delete a habit
  Future<void> deleteHabit(int habitId) async {
    try {
      final response = await _apiService.delete('habits/${habitId}');
      
      if (response['error'] == true) {
        throw Exception(response['message']);
      }
      
      return;
    } catch (e) {
      throw Exception('Failed to delete habit: $e');
    }
  }
  
  // Toggle habit completion status
  Future<Map<String, dynamic>> toggleHabitCompletion(Map<String, dynamic> habitData) async {
    try {
      // Toggle is_done status
      habitData['is_done'] = !(habitData['is_done'] ?? false);
      
      final habitId = habitData['id'];
      if (habitId == null) {
        throw Exception('Habit ID is required');
      }
      
      final response = await _apiService.post('habits/toggle/${habitId}', {
        'date': habitData['date'] ?? DateTime.now().toString().substring(0, 10),
        'completed': habitData['is_done'],
      });
      
      if (response['error'] == true) {
        throw Exception(response['message']);
      }
      
      return response['data'];
    } catch (e) {
      throw Exception('Failed to toggle habit completion: $e');
    }
  }
  
  // Get all habit categories
  Future<List<dynamic>> getCategories() async {
    try {
      final response = await _apiService.get('categories');
      
      if (response['error'] == true) {
        throw Exception(response['message']);
      }
      
      return response['data'];
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }
}
