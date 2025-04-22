import 'package:get/get.dart';
import 'api_service.dart';

class AuthService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  // User login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.post('auth/login', {
        'email': email,
        'password': password,
      });

      if (response['error'] == true) {
        throw Exception(response['message']);
      }

      return response['data'];
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // User registration
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      print('Attempting to register user: $email');
      
      // Try the signup endpoint first
      try {
        final response = await _apiService.post('auth/signup', {
          'name': name,
          'email': email,
          'password': password,
        });

        // Log the entire response for debugging
        print('Registration response received: $response (type: ${response.runtimeType})');
        
        // Check for error flag in the response
        if (response is Map && response['error'] == true) {
          print('Server returned error flag: ${response['message']}');
          throw Exception(response['message']);
        }
        
        // Check for data field in the response
        if (response is Map && response.containsKey('data')) {
          print('Registration successful, data field found'); 
          return response['data'] is Map ? response['data'] : {};
        } else {
          // If we have a valid response but no data field, return an empty map
          print('Registration successful, but no data field was found in the response');
          return {};
        }
      } catch (e) {
        print('Signup API call error: $e (type: ${e.runtimeType})');
        throw e;
      }
    } catch (e) {
      print('Registration completely failed: $e');
      throw Exception('Registration failed: $e');
    }
  }
}
