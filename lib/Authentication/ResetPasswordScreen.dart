
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import '../Library/Utils.dart' as utils;

class ResetPasswordScreen extends StatefulWidget {
  final String resetToken;

  ResetPasswordScreen({required this.resetToken});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> resetPassword(BuildContext context) async {
    String newPassword = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      utils.showCustomSnackbar('Please fill in all fields', false);
    }

    if (newPassword != confirmPassword) {
      utils.showCustomSnackbar('Passwords do not match', false);
    }

    try {
      final response = await http.post(
        Uri.parse('https://your-api-endpoint.com/api/user/resetPassword'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "token": widget.resetToken,
          "newPassword": newPassword,
        }),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        utils.showCustomSnackbar("Password reset successful!", true);
        Get.back();
        Navigator.pop(context); // Go back to login screen
      } else {
        utils.showCustomSnackbar(responseData["message"] ?? "Error occurred", false);
      }
    } catch (error) {
      utils.showCustomSnackbar('$error', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reset Password")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "New Password"),
            ),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Confirm Password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => resetPassword(context),
              child: Text("Reset Password"),
            ),
          ],
        ),
      ),
    );
  }
}
