import 'package:get/get.dart';
import 'dart:developer' as developer;
import 'dart:math' as math;

/// Mock API service that provides data locally without a backend
class ApiService extends GetxService {
  // Mock base URL (not actually used for requests)
  final RxString _mockBaseUrlRx = 'mock://habitflow/api'.obs;

  // Getter for displaying mock URL in logs
  String get baseUrl => _mockBaseUrlRx.value;

  // Random number generator for realistic mock responses
  final _random = math.Random();

  // Initialize connection - always returns true since we're using local mocks
  Future<bool> initializeConnection() async {
    developer.log('Initializing mock API service', name: 'API');
    // Simulate a small delay as if connecting to a server
    await Future.delayed(const Duration(milliseconds: 300));
    return true;
  }

  // Mock connectivity check - always returns true
  Future<bool> checkConnectivity() async {
    return true;
  }
  
  // Mock GET request
  Future<dynamic> get(String endpoint) async {
    developer.log('GET Request: $endpoint', name: 'API');
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(700)));
    return _getMockResponse(endpoint);
  }

  // Mock POST request
  Future<dynamic> post(String endpoint, dynamic data) async {
    developer.log('POST Request: $endpoint', name: 'API');
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(700)));
    return _processMockPost(endpoint, data);
  }

  // Mock PUT request
  Future<dynamic> put(String endpoint, dynamic data) async {
    developer.log('PUT Request: $endpoint', name: 'API');
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(700)));
    return _processMockUpdate(endpoint, data);
  }

  // Mock DELETE request
  Future<dynamic> delete(String endpoint) async {
    developer.log('DELETE Request: $endpoint', name: 'API');
    await Future.delayed(Duration(milliseconds: 300 + _random.nextInt(700)));
    return _processMockDelete(endpoint);
  }

  // Generate mock responses based on the endpoint
  dynamic _getMockResponse(String endpoint) {
    // Health check response
    if (endpoint == 'health') {
      return {'status': 'ok', 'message': 'Mock server is running'};
    }
    
    // User data
    if (endpoint.startsWith('user/')) {
      return {
        'id': '12345',
        'username': 'testuser',
        'email': 'test@example.com',
        'name': 'Test User',
        'createdAt': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
      };
    }
    
    // Habits list
    if (endpoint == 'habits') {
      return _getMockHabits();
    }
    
    // Dashboard data
    if (endpoint == 'dashboard') {
      return {
        'stats': {
          'streak': 5,
          'completionRate': 0.75,
          'totalHabits': 8,
          'activeHabits': 6,
        },
        'recentActivity': _getMockActivities(),
      };
    }
    
    // Calendar data
    if (endpoint.startsWith('calendar')) {
      return {
        'events': _getMockCalendarEvents(),
      };
    }
    
    // Debug/system status
    if (endpoint.startsWith('debug/')) {
      return {
        'status': 'ok',
        'system': 'mock',
        'memory': '128MB',
        'uptime': '3h 24m',
      };
    }
    
    // Return empty data for unknown endpoints
    return {};
  }
  
  // Process POST requests based on endpoint
  dynamic _processMockPost(String endpoint, dynamic data) {
    // Login response
    if (endpoint == 'auth/login') {
      final email = data['email'];
      final password = data['password'];
      
      // Simple validation - accept any non-empty values
      if (email?.isNotEmpty == true && password?.isNotEmpty == true) {
        return {
          'error': false,
          'message': 'Login successful',
          'data': {
            'token': 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
            'user': {
              'id': '12345',
              'username': email.split('@')[0],
              'email': email,
              'name': 'Test User',
            },
          }
        };
      } else {
        return {
          'error': true,
          'message': 'Invalid email or password',
          'data': null
        };
      }
    }
    
    // Registration response
    if (endpoint == 'auth/register' || endpoint == 'auth/signup') {
      final email = data['email'];
      final password = data['password'];
      final name = data['name'] ?? 'User';
      final username = data['username'] ?? email?.split('@')[0];
      
      // Simple validation
      if (email?.isNotEmpty == true && password?.isNotEmpty == true) {
        return {
          'error': false,
          'message': 'Registration successful',
          'data': {
            'token': 'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}',
            'user': {
              'id': '${_random.nextInt(10000)}',
              'username': username,
              'email': email,
              'name': name,
            },
          }
        };
      } else {
        return {
          'error': true,
          'message': 'Invalid registration data', 
          'data': null
        };
      }
    }
    
    // Create new habit
    if (endpoint == 'habits') {
      return {
        'id': '${_random.nextInt(10000)}',
        'title': data['title'] ?? 'New Habit',
        'description': data['description'] ?? '',
        'frequency': data['frequency'] ?? 'daily',
        'createdAt': DateTime.now().toIso8601String(),
        'startDate': data['startDate'] ?? DateTime.now().toIso8601String(),
        'reminderTime': data['reminderTime'],
      };
    }
    
    // Default success response
    return {'success': true};
  }
  
  // Process mock update operations
  dynamic _processMockUpdate(String endpoint, dynamic data) {
    // Simply return the data with updated timestamp to simulate update
    return {
      ...data,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
  
  // Process mock delete operations
  dynamic _processMockDelete(String endpoint) {
    return {'success': true, 'deleted': endpoint};
  }
  
  // Helper to generate mock habits
  List<Map<String, dynamic>> _getMockHabits() {
    return [
      {
        'id': '1',
        'title': 'Morning Meditation',
        'description': 'Start the day with 10 minutes of mindfulness',
        'frequency': 'daily',
        'streak': 7,
        'reminderTime': '07:00',
        'createdAt': DateTime.now().subtract(const Duration(days: 30)).toIso8601String(),
        'completedToday': _random.nextBool(),
      },
      {
        'id': '2',
        'title': 'Read a Book',
        'description': 'Read at least 20 pages',
        'frequency': 'daily',
        'streak': 3,
        'reminderTime': '21:00',
        'createdAt': DateTime.now().subtract(const Duration(days: 14)).toIso8601String(),
        'completedToday': _random.nextBool(),
      },
      {
        'id': '3',
        'title': 'Exercise',
        'description': '30 minutes of cardio',
        'frequency': 'weekly',
        'daysOfWeek': ['monday', 'wednesday', 'friday'],
        'streak': 2,
        'reminderTime': '17:30',
        'createdAt': DateTime.now().subtract(const Duration(days: 21)).toIso8601String(),
        'completedToday': _random.nextBool(),
      },
      {
        'id': '4',
        'title': 'Drink Water',
        'description': '8 glasses of water',
        'frequency': 'daily',
        'streak': 5,
        'reminderTime': null,
        'createdAt': DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
        'completedToday': _random.nextBool(),
      },
    ];
  }
  
  // Helper to generate mock activities
  List<Map<String, dynamic>> _getMockActivities() {
    return [
      {
        'id': '1',
        'type': 'completed',
        'habitId': '1',
        'habitTitle': 'Morning Meditation',
        'timestamp': DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
      },
      {
        'id': '2',
        'type': 'streak',
        'habitId': '2',
        'habitTitle': 'Read a Book',
        'streakCount': 3,
        'timestamp': DateTime.now().subtract(const Duration(hours: 10)).toIso8601String(),
      },
      {
        'id': '3',
        'type': 'created',
        'habitId': '4',
        'habitTitle': 'Drink Water',
        'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 2)).toIso8601String(),
      },
    ];
  }
  
  // Helper to generate mock calendar events
  List<Map<String, dynamic>> _getMockCalendarEvents() {
    final now = DateTime.now();
    final events = <Map<String, dynamic>>[];
    
    // Generate some events for the current month
    for (int i = -15; i < 15; i++) {
      final date = DateTime(now.year, now.month, now.day + i);
      
      // Add some random completed habits
      if (_random.nextBool()) {
        events.add({
          'id': '${_random.nextInt(1000)}',
          'date': date.toIso8601String().split('T')[0],
          'habitId': '${_random.nextInt(4) + 1}',
          'completed': true,
        });
      }
    }
    
    return events;
  }
}
