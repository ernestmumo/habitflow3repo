import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';

// Controllers
import 'controllers/login_controller.dart';
import 'controllers/signup_controller.dart';

// Theme
import 'theme/app_theme.dart';

// Services
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/habits_service.dart';
import 'services/debug_service.dart';
import 'services/profile_service.dart';
import 'services/dashboard_service.dart';
import 'services/calendar_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services in proper order with error handling
  try {
    // First, initialize API service (mock implementation)
    final apiService = Get.put(ApiService(), permanent: true);

    // Next, initialize the debug service for logging
    final debugService = await Get.put(DebugService(), permanent: true).init();
    debugService.info('HabitFlow app starting...', tag: 'Main');

    // Initialize mock data system
    debugService.info('Initializing mock data system...', tag: 'Main');
    await apiService.initializeConnection();
    debugService.info(
      'Mock data system ready at ${apiService.baseUrl}',
      tag: 'Main',
    );

    // Log mock system status
    try {
      final status = await apiService.get('debug/status');
      debugService.debug('System status: $status', tag: 'Main');
    } catch (e) {
      debugService.warning('Failed to get system status', tag: 'Main');
    }
  } catch (e, stack) {
    // Fallback to print if service initialization fails
    print('❌ Critical error during initialization: $e');
    print(stack);
  }

  // Register all services needed by the app
  try {
    // Authentication service
    Get.put(AuthService(), permanent: true);
    Get.find<DebugService>().info('Auth service initialized', tag: 'Main');

    // Habits and related services
    Get.put(HabitsService(), permanent: true);
    Get.put(ProfileService(), permanent: true);
    Get.put(DashboardService(), permanent: true);
    Get.put(CalendarService(), permanent: true);
    Get.find<DebugService>().info(
      'All feature services initialized',
      tag: 'Main',
    );

    // Make controllers permanent
    Get.put(LoginController(), permanent: true);
    Get.put(SignupController(), permanent: true);
    Get.find<DebugService>().info('Auth controllers initialized', tag: 'Main');
  } catch (e) {
    // Log any errors during service registration
    final debug = Get.find<DebugService>();
    debug.error(
      'Failed to initialize services or controllers',
      tag: 'Main',
      error: e,
    );
  }

  // Launch the app
  try {
    Get.find<DebugService>().info('Launching app UI', tag: 'Main');
    runApp(const MyApp());
  } catch (e, stack) {
    print('❌ Critical error launching app: $e');
    print(stack);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Log app build
    try {
      final debug = Get.find<DebugService>();
      debug.info('Building main app widget', tag: 'MyApp');
    } catch (_) {}

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HabitFlow',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      defaultTransition: Transition.fade,
      // Add error handling for uncaught exceptions
      onInit: () {
        FlutterError.onError = (FlutterErrorDetails details) {
          try {
            final debug = Get.find<DebugService>();
            debug.error(
              'Uncaught Flutter error: ${details.exception}',
              tag: 'FlutterError',
              error: details.exception,
              stackTrace: details.stack,
            );
          } catch (_) {
            // Fallback if debug service isn't available
            FlutterError.presentError(details);
          }
        };
      },
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/signup', page: () => SignupScreen()),
        GetPage(name: '/home', page: () => HomeScreen()),
      ],
    );
  }
}
