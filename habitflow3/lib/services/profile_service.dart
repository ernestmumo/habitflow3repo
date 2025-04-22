import 'package:get/get.dart';
import 'api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();
  
  // Get user profile data
  Future<Map<String, dynamic>> getUserProfile(int userId) async {
    try {
      final response = await _apiService.get('profile/${userId}');
      
      if (response['error'] == true) {
        throw Exception(response['message']);
      }
      
      return response['data'];
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }
  
  // Update user profile
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final userId = profileData['user_id'];
      if (userId == null) {
        throw Exception('User ID is required');
      }
      
      final response = await _apiService.put('profile/${userId}', profileData);
      
      if (response['error'] == true) {
        throw Exception(response['message']);
      }
      
      return response['data'];
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
  
  // Upload profile image
  Future<String> uploadProfileImage(int userId, String imagePath) async {
    try {
      final uri = Uri.parse('${_apiService.baseUrl}/profile/${userId}/upload');
      
      var request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('profile_image', imagePath));
      
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      // Parse response manually
      final jsonResponse = json.decode(response.body);
      
      if (jsonResponse['error'] == true) {
        throw Exception(jsonResponse['message']);
      }
      
      return jsonResponse['data']['profile_image'];
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }
}
