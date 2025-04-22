import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final isLoading = false.obs;
  final emailError = RxString('');
  final passwordError = RxString('');
  final isPasswordVisible = false.obs; // Added for password visibility toggle
  
  // Get the auth service instance
  final AuthService _authService = Get.find<AuthService>();
  
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  
  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  
  // Validate email as user types
  void validateEmail(String value) {
    if (value.isEmpty) {
      emailError.value = 'Email cannot be empty';
    } else if (!GetUtils.isEmail(value)) {
      emailError.value = 'Please enter a valid email';
    } else {
      emailError.value = '';
    }
  }
  
  // Validate password as user types
  void validatePassword(String value) {
    if (value.isEmpty) {
      passwordError.value = 'Password cannot be empty';
    } else if (value.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
    } else {
      passwordError.value = '';
    }
  }
  
  bool validateInputs() {
    bool isValid = true;
    
    // Reset previous errors
    emailError.value = '';
    passwordError.value = '';
    
    // Validate email
    if (emailController.text.isEmpty) {
      emailError.value = 'Email cannot be empty';
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text)) {
      emailError.value = 'Please enter a valid email';
      isValid = false;
    }
    
    // Validate password
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password cannot be empty';
      isValid = false;
    } else if (passwordController.text.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      isValid = false;
    }
    
    return isValid;
  }
  
  Future<void> login() async {
    if (!validateInputs()) return;
    
    try {
      isLoading.value = true;
      
      // Use the auth service to verify credentials with the backend
      final userData = await _authService.login(
        emailController.text.trim(), 
        passwordController.text
      );
      
      // Store user data (could use GetStorage or shared_preferences here)
      // For now, just passing minimal data to the next screen
      Map<String, dynamic> userInfo = {
        'id': userData['id'],
        'name': userData['name'],
        'email': userData['email']
      };
      
      // If login is successful, navigate to home screen with user data
      Get.offAllNamed('/home', arguments: userInfo);
      
    } catch (e) {
      // Show more user-friendly error messages
      String errorMessage = 'Failed to login';
      
      if (e.toString().contains('User not found')) {
        errorMessage = 'User does not exist. Please sign up first.';
      } else if (e.toString().contains('Invalid password')) {
        errorMessage = 'Invalid password. Please try again.';
      } else if (e.toString().contains('No internet')) {
        errorMessage = 'No internet connection. Please check your network.';
      }
      
      Get.snackbar(
        'Login Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(10),
      );
      
      // Log the detailed error for debugging
      print('Login error: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  void goToSignup() {
    Get.toNamed('/signup');
  }
}
