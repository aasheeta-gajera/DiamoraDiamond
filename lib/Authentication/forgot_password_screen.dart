import 'dart:async';
import 'dart:convert';
import 'package:daimo/Authentication/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../Library/AppColour.dart';
import '../Library/AppStrings.dart';
import '../Library/AppStyle.dart';
import '../Library/Utils.dart' as utils;

class ForgotResetPasswordScreen extends StatefulWidget {
  @override
  _ForgotResetPasswordScreenState createState() => _ForgotResetPasswordScreenState();
}

class _ForgotResetPasswordScreenState extends State<ForgotResetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Timer? _debounce;
  String? _resetToken;
  bool isResetMode = false;

  void _onEmailChanged(String email) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(Duration(seconds: 1), () {
      if (email.isNotEmpty) {
        _sendForgotPasswordRequest(email);
      }
    });
  }

  Future<void> _sendForgotPasswordRequest(String email) async {
    final url = Uri.parse("https://ad81-2409-4080-9c9b-49b7-c54a-ce8e-32f0-202b.ngrok-free.app/api/user/forgotPassword"); // Update with your API
    final response = await http.post(url, body: jsonEncode({"email": email}),
        headers: {"Content-Type": "application/json"});

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _resetToken = data["resetToken"];
        isResetMode = true;
      });
      utils.showCustomSnackbar('Reset token received. Enter new password.', true);
    } else {
      // utils.showCustomSnackbar("data", false);
    }
  }

  Future<void> _resetPassword() async {
    if (passwordController.text != confirmPasswordController.text) {
      utils.showCustomSnackbar("Passwords do not match!", false);
      return;
    }

    final url = Uri.parse("https://ad81-2409-4080-9c9b-49b7-c54a-ce8e-32f0-202b.ngrok-free.app/api/user/resetPassword"); // Update API URL
    final response = await http.post(url,
        body: jsonEncode({
          "token": _resetToken,
          "newPassword": passwordController.text
        }),
        headers: {"Content-Type": "application/json"});

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      utils.showCustomSnackbar("Password reset successful!", true);
      Get.to(() => Loginscreen());
      setState(() {
        isResetMode = false;
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
      });
    } else {
      utils.showCustomSnackbar(data["message"], false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
        child: Column(
          children: [
            Text(
              AppString.forgotPassword,
              style: TextStyleHelper.bigBlack.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20,),
            if (!isResetMode)
              Column(
                children: [
                  utils.buildTextField('Enter your email', emailController, textColor: AppColors.primaryBlack, hintColor: Colors.grey,onChange: _onEmailChanged),
                ],
              ),
            if (isResetMode)
              Column(
                children: [
                  utils.buildTextField('New Password', passwordController, textColor: AppColors.primaryBlack, hintColor: Colors.grey),
                  utils.buildTextField('Confirm Password', confirmPasswordController, textColor: AppColors.primaryBlack, hintColor: Colors.grey),
                  SizedBox(height: 20),
                  utils.PrimaryButton(
                    onPressed: _resetPassword,
                    text: 'Reset Password',
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
