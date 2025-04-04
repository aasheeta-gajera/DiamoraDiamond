
import 'dart:async';
import 'dart:convert';
import 'package:daimo/Authentication/Login.dart';
import 'package:daimo/Library/ApiService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../Library/AppColour.dart';
import '../Library/AppImages.dart';
import '../Library/AppStrings.dart';
import '../Library/AppStyle.dart';
import '../Library/Utils.dart' as utils;

class ForgotResetPassword extends StatefulWidget {
  const ForgotResetPassword({super.key});

  @override
  _ForgotResetPasswordState createState() => _ForgotResetPasswordState();
}

class _ForgotResetPasswordState extends State<ForgotResetPassword> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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

  bool isLoading = false;

  Future<void> _sendForgotPasswordRequest(String email) async {
    setState(() => isLoading = true);

    try {
      final url = Uri.parse("${ApiService.baseUrl}/forgotPassword");
      final response = await http.post(
        url,
        body: jsonEncode({"email": email}),
        headers: {"Content-Type": "application/json"},
      );
      setState(() => isLoading = false);

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          _resetToken = data["resetToken"];
          isResetMode = true;
        });
        utils.showCustomSnackbar(
          'Reset token received. Enter new password.',
          true,
        );
      } else {
        utils.showCustomSnackbar(data["message"], false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      utils.showCustomSnackbar('${e}', false);
    }
  }

  Future<void> _resetPassword() async {
    if (passwordController.text != confirmPasswordController.text) {
      utils.showCustomSnackbar("Passwords do not match!", false);
      return;
    }
    setState(() => isLoading = true);

    try {
      final url = Uri.parse("${ApiService.baseUrl}/resetPassword");
      final response = await http.post(
        url,
        body: jsonEncode({
          "token": _resetToken,
          "newPassword": passwordController.text,
        }),
        headers: {"Content-Type": "application/json"},
      );

      setState(() => isLoading = false);

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        utils.showCustomSnackbar("Password reset successful!", true);
        Get.to(() => LogIn());
        setState(() {
          isResetMode = false;
          emailController.clear();
          passwordController.clear();
          confirmPasswordController.clear();
        });
      } else {
        utils.showCustomSnackbar(data["message"], false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      utils.showCustomSnackbar('${e}', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColour,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppImages.authChoice, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
            child: Column(
              children: [
                Text(
                  isResetMode == false?AppString.forgotPassword:AppString.resetPassword,
                  style: TextStyleHelper.extraLargeWhite.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                if (!isResetMode)
                  Column(
                    children: [
                      utils.buildTextField(
                        AppString.enterMail,
                        emailController,
                        textColor: AppColors.primaryColour,
                        hintColor: Colors.white,
                        onChange: _onEmailChanged,
                      ),
                    ],
                  ),
                if (isResetMode)
                  Column(
                    children: [
                      utils.buildTextField(
                        AppString.newPassword,
                        passwordController,
                        textColor: AppColors.primaryWhite,
                        hintColor: Colors.grey,
                      ),
                      utils.buildTextField(
                        AppString.confirmPassword,
                        confirmPasswordController,
                        textColor: AppColors.primaryWhite,
                        hintColor: Colors.grey,
                      ),
                      SizedBox(height: 20),
                      utils.PrimaryButton(
                        onPressed: _resetPassword,
                        text: AppString.resetPassword,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
