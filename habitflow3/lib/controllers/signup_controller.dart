import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

class SignupController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  final isLoading = false.obs;
  final nameError = RxString('');
  final emailError = RxString('');
  final passwordError = RxString('');
  final confirmPasswordError = RxString('');
  
  // For password visibility toggle
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  
  // Get the auth service instance
  final AuthService _authService = Get.find<AuthService>();
  
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
  
  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
  
  // Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }
  
  // Validate name field as user types
  void validateName(String value) {
    if (value.isEmpty) {
      nameError.value = 'Name cannot be empty';
    } else {
      nameError.value = '';
    }
  }
  
  // Validate email field as user types
  void validateEmail(String value) {
    if (value.isEmpty) {
      emailError.value = 'Email cannot be empty';
    } else if (!GetUtils.isEmail(value)) {
      emailError.value = 'Please enter a valid email';
    } else {
      emailError.value = '';
    }
  }
  
  // Validate password field as user types
  void validatePassword(String value) {
    if (value.isEmpty) {
      passwordError.value = 'Password cannot be empty';
    } else if (value.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
    } else {
      passwordError.value = '';
      // Check confirm password when password changes
      validateConfirmPassword(confirmPasswordController.text);
    }
  }
  
  // Validate confirm password field as user types
  void validateConfirmPassword(String value) {
    if (value.isEmpty) {
      confirmPasswordError.value = 'Confirm password cannot be empty';
    } else if (value != passwordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
    } else {
      confirmPasswordError.value = '';
    }
  }
  
  bool validateInputs() {
    bool isValid = true;
    
    // Reset previous errors
    nameError.value = '';
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
    
    // Validate name
    if (nameController.text.isEmpty) {
      nameError.value = 'Name cannot be empty';
      isValid = false;
    }
    
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
    
    // Validate confirm password
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
      isValid = false;
    } else if (confirmPasswordController.text != passwordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
      isValid = false;
    }
    
    return isValid;
  }
  
  Future<void> signup() async {
    if (!validateInputs()) return;
    
    try {
      isLoading.value = true;
      
      // Use auth service to register user in the backend
      await _authService.register(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text
      );
      
      // If signup is successful, navigate to login screen
      Get.offAllNamed('/login');
      Get.snackbar(
        'Success',
        'Account created successfully! Please login.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      
    } catch (e) {
      // Show more user-friendly error messages
      String errorMessage = 'Failed to create account';
      
      if (e.toString().contains('Email already exists')) {
        errorMessage = 'Email already registered. Please use a different email or login.';
      } else if (e.toString().contains('No internet')) {
        errorMessage = 'No internet connection. Please check your network.';
      }
      
      Get.snackbar(
        'Registration Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(10),
      );
      
      // Log the detailed error for debugging
      print('Signup error: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  void goToLogin() {
    Get.toNamed('/login');
  }
}
