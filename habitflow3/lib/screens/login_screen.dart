import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  // Use late initialization to avoid issues with controller lifecycle
  late final LoginController controller;

  LoginScreen({Key? key}) : super(key: key) {
    // Ensure controller is initialized when screen is created
    if (!Get.isRegistered<LoginController>()) {
      controller = Get.put(LoginController());
    } else {
      controller = Get.find<LoginController>();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Obx(
        () =>
            controller.isLoading.value
                ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
                : SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: deviceWidth * 0.08,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: deviceHeight * 0.08),
                          // Logo and App Name
                          Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  size: 80,
                                  color: Theme.of(context).primaryColor,
                                ),
                                SizedBox(height: deviceHeight * 0.02),
                                Text(
                                  'HabitFlow',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.displayMedium?.copyWith(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: deviceHeight * 0.01),
                                Text(
                                  'Track your habits, improve your life',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: deviceHeight * 0.06),
                          // Login Card with Elevation and Box Shadow
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardTheme.color,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(
                                    context,
                                  ).shadowColor.withOpacity(0.1),
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
                                Text(
                                  'Login',
                                  style:
                                      Theme.of(
                                        context,
                                      ).textTheme.headlineMedium,
                                ),
                                SizedBox(height: deviceHeight * 0.03),
                                // Email Field with improved decoration
                                Obx(
                                  () => TextField(
                                    controller: controller.emailController,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      hintText: 'Enter your email',
                                      prefixIcon: Icon(Icons.email_outlined),
                                      errorText:
                                          controller.emailError.value.isEmpty
                                              ? null
                                              : controller.emailError.value,
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: (value) {
                                      controller.validateEmail(value);
                                    },
                                  ),
                                ),
                                SizedBox(height: deviceHeight * 0.02),
                                // Password Field with visibility toggle
                                Obx(
                                  () => TextField(
                                    controller: controller.passwordController,
                                    obscureText:
                                        !controller.isPasswordVisible.value,
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
                                      errorText:
                                          controller.passwordError.value.isEmpty
                                              ? null
                                              : controller.passwordError.value,
                                    ),
                                    onChanged: (value) {
                                      controller.validatePassword(value);
                                    },
                                  ),
                                ),
                                SizedBox(height: deviceHeight * 0.01),
                                // Forgot Password with theme styling
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      // Add forgot password functionality
                                    },
                                    child: Text('Forgot Password?'),
                                  ),
                                ),
                                SizedBox(height: deviceHeight * 0.03),
                                // Login Button with modern design
                                ElevatedButton(
                                  onPressed: () => controller.login(),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Login',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(Icons.arrow_forward),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: deviceHeight * 0.04),
                          // Sign Up Link with theme styling
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                TextButton(
                                  onPressed: () => Get.toNamed('/signup'),
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
      ),
    );
  }
}
