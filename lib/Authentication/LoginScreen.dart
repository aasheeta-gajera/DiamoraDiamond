
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Library/AppColour.dart';
import '../Library/AppStrings.dart';
import '../Library/AppStyle.dart';
import 'package:get/get.dart';
import '../Dashboard/Dashboard.dart';
import '../Library/Utils.dart' as utils;
import '../Library/api_service.dart';
import 'forgot_password_screen.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future _login() async {
    setState(() => isLoading = true);

    final String url = '${ApiService.baseUrl}/login';
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> body = {
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
    };

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String token = responseData['token']; // Assuming API returns a token
        utils.showCustomSnackbar('Login successful!', true);
        
        Get.to(() => DiamondHomePage(token: token));

      } else {
        utils.showCustomSnackbar(jsonDecode(response.body)['message'] ?? 'Invalid credentials', false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      utils.showCustomSnackbar('Error: Unable to connect to server', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppString.logIn,
                style: TextStyleHelper.bigBlack.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              utils.buildTextField(AppString.email, emailController, textColor: AppColors.primaryBlack, hintColor: Colors.grey),
              const SizedBox(height: 20),
              utils.buildTextField(AppString.password, passwordController, obscureText: true, textColor: AppColors.primaryBlack, hintColor: Colors.grey),
              const SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator(color: AppColors.primaryBlack)
                  : utils.PrimaryButton(
                text: AppString.submit,
                backgroundColor: AppColors.primaryBlack,
                textColor: AppColors.primaryWhite,
                onPressed: _login,
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => {
                  Get.to(ForgotResetPasswordScreen())
                },
                child: Text(
                  AppString.forgotPassword,
                  style: TextStyleHelper.mediumBlack.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
