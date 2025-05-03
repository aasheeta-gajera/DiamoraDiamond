import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Dashboard/Admin/AdminDashboard.dart';
import '../Dashboard/User/CustomerDashboard.dart';
import '../Library/ApiService.dart';
import '../Library/AppColour.dart';
import '../Library/AppImages.dart';
import '../Library/AppStrings.dart';
import '../Library/AppStyle.dart';
import '../Library/SharedPrefService.dart';
import 'ForgotPassword.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../Library/Utils.dart' as utils;
import '../Library/ApiService.dart';
import 'Registration.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    String? token = SharedPrefService.getString('auth_token');
    String? userTypes = await SharedPrefService.getString('userType') ?? "";

    if (token != null && token.isNotEmpty) {
      if (userTypes == "admin") {
        Get.off(() => AdminDashboard(token: token));
      } else {
        Get.off(() => CustomerDashboard(token: token));
      }
    }
  }

  Future<void> _login() async {
    setState(() => isLoading = true);

    final String url = '${ApiService.baseUrl}/login';
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> body = {
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String token = responseData['token'] ?? '';
        String email = responseData['user']['email'] ?? '';
        String name = responseData['user']['name'] ?? '';
        String userId = responseData['user']['_id'] ?? '';
        String mobile = responseData['user']['mobile'] ?? '';
        String city = responseData['user']['city'] ?? '';
        String address = responseData['user']['address'] ?? '';
        String contactName = responseData['user']['contact_name'] ?? '';
        String idProof = responseData['user']['idProof'] ?? '';
        String licenseCopy = responseData['user']['licenseCopy'] ?? '';
        String taxCertificate = responseData['user']['taxCertificate'] ?? '';
        String partnerCopy = responseData['user']['partnerCopy'] ?? '';
        String userType = responseData['user']['userType'] ?? '';

        // Save User Data
        await SharedPrefService.setString('auth_token', token);
        await SharedPrefService.setString('user_email', email);
        await SharedPrefService.setString('user_name', name);
        await SharedPrefService.setString('userId', userId);
        await SharedPrefService.setString('mobileNo', mobile);
        await SharedPrefService.setString('Address', address);
        await SharedPrefService.setString('contactName', contactName);
        await SharedPrefService.setString('City', city);
        await SharedPrefService.setString('id_proof', idProof);
        await SharedPrefService.setString('license_copy', licenseCopy);
        await SharedPrefService.setString('tax_certificate', taxCertificate);
        await SharedPrefService.setString('partner_copy', partnerCopy);
        await SharedPrefService.setString('userType', userType);

        utils.showCustomSnackbar('Login successful!', true);
        print("aasfdbhjiohgkjkoih  ${userId}");
        print("aasfdbhjiohgkjkoih  ${responseData}");

        if (userType == "admin") {
          Get.off(() => AdminDashboard(token: token));
        } else {
          Get.off(() => CustomerDashboard(token: token));
        }
      } else {
        utils.showCustomSnackbar(
          jsonDecode(response.body)['message'] ?? 'Invalid credentials',
          false,
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      utils.showCustomSnackbar('Error: ${e.toString()}', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColour,
              AppColors.secondaryColour,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo with blur effect
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Blurred backdrop inside a circle
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.transparent,
                                Colors.white.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),

                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: ClipOval(
                              child: Image.asset(
                                AppImages.splashImage,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        ClipOval(
                          child: Image.asset(
                            AppImages.splashImage,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  Text(
                    AppString.welcomeBack,
                    style: TextStyleHelper.extraLargeWhite.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppString.pleaseSignIn,
                    style: TextStyleHelper.mediumWhite.copyWith(
                      fontSize: 15,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Email
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyleHelper.mediumBlack,
                    decoration: InputDecoration(
                      labelText: AppString.email,
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: AppColors.primaryWhite,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: passwordController,
                    obscureText: !_isPasswordVisible,
                    style: TextStyleHelper.mediumBlack,
                    decoration: InputDecoration(
                      labelText: AppString.password,
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () =>
                            setState(() => _isPasswordVisible = !_isPasswordVisible),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: AppColors.primaryWhite,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 6,
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                        AppString.logIn,
                        style: TextStyleHelper.mediumBlack.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => Get.to(() => const ForgotResetPassword()),
                      icon: const Icon(
                        Icons.lock_outline,
                        size: 18,
                        color: Colors.white70,
                      ),
                      label: Text(
                        "Forgot Password?",
                        style: TextStyleHelper.mediumWhite.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 0.3,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerRight,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => Get.to(() => const Registration()),
                      icon: const Icon(
                        Icons.app_registration,
                        size: 18,
                        color: Colors.white70,
                      ),
                      label: Text(
                        "Sign Up",
                        style: TextStyleHelper.mediumWhite.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 0.3,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerRight,
                      ),
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
