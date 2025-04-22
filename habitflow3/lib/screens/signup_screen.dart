import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/signup_controller.dart';

class SignupScreen extends StatelessWidget {
  // Use late initialization to avoid issues with controller lifecycle
  late final SignupController controller;

  SignupScreen({Key? key}) : super(key: key) {
    // Ensure controller is initialized when screen is created
    if (!Get.isRegistered<SignupController>()) {
      controller = Get.put(SignupController());
    } else {
      controller = Get.find<SignupController>();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Obx(() => controller.isLoading.value
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.08),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: deviceHeight * 0.05),
                      // Header
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.person_add_outlined,
                              size: 70,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(height: deviceHeight * 0.02),
                            Text(
                              'Create Account',
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: deviceHeight * 0.01),
                            Text(
                              'Join HabitFlow and start your journey',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: deviceHeight * 0.04),
                      // Signup Form Card with Elevation
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).shadowColor.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Full Name Field
                            Obx(() => TextField(
                              controller: controller.nameController,
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                hintText: 'Enter your full name',
                                prefixIcon: Icon(Icons.person_outline),
                                errorText: controller.nameError.value.isEmpty
                                    ? null
                                    : controller.nameError.value,
                              ),
                              onChanged: (value) {
                                controller.validateName(value);
                              },
                            )),
                            SizedBox(height: deviceHeight * 0.02),
                            // Email Field
                            Obx(() => TextField(
                              controller: controller.emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'Enter your email',
                                prefixIcon: Icon(Icons.email_outlined),
                                errorText: controller.emailError.value.isEmpty
                                    ? null
                                    : controller.emailError.value,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                controller.validateEmail(value);
                              },
                            )),
                            SizedBox(height: deviceHeight * 0.02),
                            // Password Field with visibility toggle
                            Obx(() => TextField(
                              controller: controller.passwordController,
                              obscureText: !controller.isPasswordVisible.value,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                prefixIcon: Icon(Icons.lock_outlined),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isPasswordVisible.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    controller.togglePasswordVisibility();
                                  },
                                ),
                                errorText: controller.passwordError.value.isEmpty
                                    ? null
                                    : controller.passwordError.value,
                              ),
                              onChanged: (value) {
                                controller.validatePassword(value);
                              },
                            )),
                            SizedBox(height: deviceHeight * 0.02),
                            // Confirm Password Field with visibility toggle
                            Obx(() => TextField(
                              controller: controller.confirmPasswordController,
                              obscureText: !controller.isConfirmPasswordVisible.value,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                hintText: 'Confirm your password',
                                prefixIcon: Icon(Icons.lock_outlined),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isConfirmPasswordVisible.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    controller.toggleConfirmPasswordVisibility();
                                  },
                                ),
                                errorText: controller.confirmPasswordError.value.isEmpty
                                    ? null
                                    : controller.confirmPasswordError.value,
                              ),
                              onChanged: (value) {
                                controller.validateConfirmPassword(value);
                              },
                            )),
                            SizedBox(height: deviceHeight * 0.03),
                            // Signup Button
                            ElevatedButton(
                              onPressed: () => controller.signup(),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Sign Up',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: deviceHeight * 0.04),
                      // Login Link
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account? ",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text(
                                'Login',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
    );
  }
}
