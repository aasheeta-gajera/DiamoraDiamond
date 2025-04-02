import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Dashboard/Admin/AdminDashboard.dart';
import '../Dashboard/User/CustomerDashboard.dart';
import '../Library/AppColour.dart';
import '../Library/AppImages.dart';
import '../Library/AppStrings.dart';
import '../Library/AppStyle.dart';
import 'package:get/get.dart';
import '../Library/Utils.dart' as utils;
import '../Library/ApiService.dart';
import '../Library/SharedPrefService.dart';
import 'ForgotPassword.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

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
        String userId = responseData['user']['user_id'] ?? '';
        String mobile = responseData['user']['mobile'] ?? '';
        String city = responseData['user']['city'] ?? '';
        String address = responseData['user']['address'] ?? '';
        String contactName = responseData['user']['contact_name'] ?? '';
        String idProof = responseData['user']['idProof'] ?? '';
        String licenseCopy = responseData['user']['licenseCopy'] ?? '';
        String taxCertificate = responseData['user']['taxCertificate'] ?? '';
        String partnerCopy = responseData['user']['partnerCopy'] ?? '';
        String userType = responseData['user']['userType'] ?? ''; // Default to 'customer']

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
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(AppImages.authChoice, fit: BoxFit.cover),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // App Logo
                  Image.asset(
                    AppImages.splashImage, // Ensure logo is in assets/images
                    height: 100,
                  ),
                  const SizedBox(height: 20),

                  // Login Text
                  Text(
                    AppString.logIn,
                    style: TextStyleHelper.bigBlack.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColour,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Email Input Field
                  // Email Input Field
                  _buildInputField(
                    AppString.email,
                    "Enter your email",
                    emailController,
                    Icons.email, textColor: AppColors.primaryColour, hintColor: Colors.grey,
                  ),
                  const SizedBox(height: 15),

                  // Password Input Field
                  _buildInputField(
                    AppString.password,
                    "Enter your password",
                    passwordController,
                    Icons.lock,
                    obscureText: true, textColor: AppColors.primaryColour, hintColor: Colors.grey,
                  ),

                  const SizedBox(height: 20),

                  // Login Button
                  isLoading
                      ? CircularProgressIndicator(color: AppColors.primaryColour):
                  utils.PrimaryButton(text: AppString.submit, onPressed: _login),
                  const SizedBox(height: 15),

                  // Forgot Password
                  GestureDetector(
                    onTap: () => Get.to(ForgotResetPassword()),
                    child: Text(
                      AppString.forgotPassword,
                      style: TextStyleHelper.mediumBlack.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build Input Field with Custom Styling
  Widget _buildInputField(
      String label,
      String hint,
      TextEditingController controller,
      IconData icon, {
        bool readOnly = false,
        required Color textColor,
        required MaterialColor hintColor,
        TextInputType keyboardType = TextInputType.text,
        bool obscureText = false,
        Function(String)? onChange,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        onChanged: onChange,
        controller: controller,
        obscureText: obscureText,
        readOnly: readOnly,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          labelText: label,
          hintStyle: const TextStyle(color: Colors.white), // Set hint text color to white
          labelStyle: const TextStyle(color: Colors.white), // Optional: Set label text color to white
          prefixIcon: Icon(icon, color: Colors.white),
          filled: true,
          fillColor: Colors.white.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }


  // Build Gradient Button
  Widget _buildGradientButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.deepPurpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyleHelper.mediumBlack.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
