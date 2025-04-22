import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:get/get.dart';

import 'api_service.dart';

/// A comprehensive debugging service for the HabitFlow app
class DebugService extends GetxService {
  // Observable log level - can be changed at runtime
  final logLevel = 'info'.obs;
  
  // Using mock data system, so always connected
  final isBackendConnected = true.obs;
  
  // Log settings
  final enableConsoleLogs = true.obs;
  final enableFileLogs = true.obs;
  final maxLogRetention = 7.obs; // days
  
  // Debug settings
  final verboseMode = false.obs;
  
  // API Service reference
  final ApiService _apiService = Get.find<ApiService>();
  
  // Log file
  File? _logFile;
  
  /// Log levels (ordered by severity)
  static const LOG_LEVELS = ['debug', 'info', 'warning', 'error'];
  
  /// Initialize the debug service
  Future<DebugService> init() async {
    developer.log('Initializing debug service...', name: 'Debug');
    
    // Set up log file if file logging is enabled
    if (enableFileLogs.value) {
      try {
        // Create logs directory in the current directory (for simplicity)
        final logDir = Directory('logs');
        if (!await logDir.exists()) {
          await logDir.create(recursive: true);
        }
        
        // Create log file with today's date
        final now = DateTime.now();
        final fileName = 'habitflow_${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}.log';
        _logFile = File('${logDir.path}${Platform.pathSeparator}$fileName');
        
        // Add header
        if (!await _logFile!.exists()) {
          await _logFile!.writeAsString('=== HabitFlow Log - ${now.toString()} ===\n\n');
        }
        
        // Clean up old logs
        await _cleanupOldLogs(logDir, maxLogRetention.value);
        
        debug('Log file initialized at ${_logFile!.path}', tag: 'Debug');
      } catch (e) {
        error('Failed to create log file: $e', tag: 'Debug');
        enableFileLogs.value = false;
      }
    }
    
    // We're using mock data, so we're always connected
    isBackendConnected.value = true;
    info('Mock data system connection: READY', tag: 'Debug');
    
    return this;
  }
  

  
  /// Clean up old log files
  Future<void> _cleanupOldLogs(Directory logDir, int retentionDays) async {
    try {
      final now = DateTime.now();
      final files = await logDir.list().toList();
      
      for (var fileEntity in files) {
        if (fileEntity is File && fileEntity.path.endsWith('.log')) {
          final fileName = fileEntity.uri.pathSegments.last;
          // Parse date from filename (format: habitflow_YYYY-MM-DD.log)
          final dateStr = fileName.split('_')[1].split('.')[0];
          try {
            final fileDate = DateTime.parse(dateStr);
            final age = now.difference(fileDate).inDays;
            
            if (age > retentionDays) {
              await fileEntity.delete();
              debug('Deleted old log file: $fileName (age: $age days)', tag: 'Debug');
            }
          } catch (e) {
            warning('Could not parse date from log file: $fileName', tag: 'Debug');
          }
        }
      }
    } catch (e) {
      warning('Error cleaning up old logs: $e', tag: 'Debug');
    }
  }
  
  /// Log a debug message
  void debug(String message, {String tag = 'HabitFlow'}) {
    _log('debug', message, tag: tag);
  }
  
  /// Log an info message
  void info(String message, {String tag = 'HabitFlow'}) {
    _log('info', message, tag: tag);
  }
  
  /// Log a warning message
  void warning(String message, {String tag = 'HabitFlow'}) {
    _log('warning', message, tag: tag);
  }
  
  /// Log an error message
  void error(String message, {String tag = 'HabitFlow', Object? error, StackTrace? stackTrace}) {
    _log('error', message, tag: tag, error: error, stackTrace: stackTrace);
  }
  
  /// Log API requests and responses
  void logApiEvent(String method, String endpoint, {dynamic requestData, dynamic responseData, int? statusCode, String? errorMessage}) {
    final buffer = StringBuffer();
    buffer.write('API $method ${_apiService.baseUrl}/$endpoint');
    
    if (statusCode != null) {
      buffer.write(' [Status: $statusCode]');
    }
    
    final logLevel = errorMessage != null ? 'error' : 'debug';
    
    _log(logLevel, buffer.toString(), tag: 'API', 
      additionalInfo: {
        if (requestData != null) 'request': requestData,
        if (responseData != null) 'response': responseData,
        if (errorMessage != null) 'error': errorMessage,
      }
    );
  }
  
  /// Get server diagnostics
  Future<Map<String, dynamic>> getServerDiagnostics() async {
    try {
      final response = await _apiService.get('debug/status');
      return response;
    } catch (e) {
      error('Failed to get mock system diagnostics: $e', tag: 'Debug');
      return {
        'status': 'error',
        'error': e.toString(),
      };
    }
  }
  
  /// Get database diagnostics
  Future<Map<String, dynamic>> getDatabaseDiagnostics() async {
    try {
      // Return mock data about the database
      return {
        'status': 'online',
        'type': 'mock',
        'records': {
          'users': 3,
          'habits': 8,
          'completed': 24,
        },
        'latency': '0ms',
      };
    } catch (e) {
      error('Failed to get mock database diagnostics: $e', tag: 'Debug');
      return {
        'status': 'error',
        'error': e.toString(),
      };
    }
  }
  
  /// Set the log level (client-side only in mock mode)
  Future<bool> setServerLogLevel(String level) async {
    try {
      // Just set the client log level
      logLevel.value = level;
      info('Log level set to $level', tag: 'Debug');
      return true;
    } catch (e) {
      error('Failed to set log level: $e', tag: 'Debug');
      return false;
    }
  }
  
  /// Internal log method
  void _log(String level, String message, {
    required String tag,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? additionalInfo
  }) {
    // Skip if level is below current log level
    final levelIndex = LOG_LEVELS.indexOf(level);
    final currentLevelIndex = LOG_LEVELS.indexOf(logLevel.value);
    
    if (levelIndex < currentLevelIndex) {
      return;
    }
    
    final now = DateTime.now();
    final timestamp = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}.${now.millisecond.toString().padLeft(3, '0')}';
    
    // Format the log message
    final formattedMessage = '[$timestamp] $level/$tag: $message';
    
    // Add error and stack trace
    String fullMessage = formattedMessage;
    if (error != null) {
      fullMessage += '\nError: $error';
    }
    if (stackTrace != null) {
      fullMessage += '\nStack trace:\n$stackTrace';
    }
    if (additionalInfo != null && verboseMode.value) {
      fullMessage += '\nAdditional info:';
      additionalInfo.forEach((key, value) {
        final valueStr = value is Map ? jsonEncode(value) : value.toString();
        fullMessage += '\n  $key: $valueStr';
      });
    }
    
    // Console logging
    if (enableConsoleLogs.value) {
      if (level == 'error') {
        developer.log(fullMessage, name: tag, error: error, stackTrace: stackTrace);
      } else {
        developer.log(fullMessage, name: tag);
      }
    }
    
    // File logging
    if (enableFileLogs.value && _logFile != null) {
      try {
        _logFile!.writeAsStringSync('$fullMessage\n\n', mode: FileMode.append);
      } catch (e) {
        // Fallback to console if file write fails
        developer.log('Failed to write to log file: $e', name: 'Debug');
      }
    }
  }
  
  /// Get all logs from file
  Future<String> getLogsContent() async {
    if (!enableFileLogs.value || _logFile == null) {
      return 'File logging is disabled';
    }
    
    try {
      if (await _logFile!.exists()) {
        return await _logFile!.readAsString();
      } else {
        return 'Log file does not exist';
      }
    } catch (e) {
      return 'Error reading log file: $e';
    }
  }
  
  /// Clear all logs
  Future<bool> clearLogs() async {
    if (!enableFileLogs.value || _logFile == null) {
      return false;
    }
    
    try {
      if (await _logFile!.exists()) {
        await _logFile!.writeAsString('=== HabitFlow Log - ${DateTime.now().toString()} (Cleared) ===\n\n');
        info('Logs cleared', tag: 'Debug');
        return true;
      }
      return false;
    } catch (e) {
      error('Failed to clear logs: $e', tag: 'Debug');
      return false;
    }
  }
}
