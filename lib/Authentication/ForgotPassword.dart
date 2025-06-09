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
import 'package:shared_preferences/shared_preferences.dart';

class ForgotResetPassword extends StatefulWidget {
  const ForgotResetPassword({super.key});

  @override
  State<ForgotResetPassword> createState() => _ForgotResetPasswordState();
}

class _ForgotResetPasswordState extends State<ForgotResetPassword> {

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
  bool _isResetMode = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  Timer? _debounce;
  String? _resetToken;
  // bool isResetMode = false;

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
      // Prepare plain JSON body
      final body = {"email": email};

      // Encrypt body
      final encryptedBody = jsonEncode({"data": ApiService.encryptData(jsonEncode(body))});

      final url = Uri.parse("${ApiService.baseUrl}/Auth/forgotPassword");
      final response = await http.post(
        url,
        body: encryptedBody,
        headers: {"Content-Type": "application/json"},
      );

      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        // Decrypt response body
        final responseBody = jsonDecode(response.body);
        final decryptedJson = ApiService.decryptData(responseBody['data']);
        final data = jsonDecode(decryptedJson);

        setState(() {
          _resetToken = data["resetToken"];
          _isResetMode = true;
        });
        utils.showCustomSnackbar('Reset token received. Enter new password.', true);
      } else {
        // Optionally decrypt error message if backend encrypts error also
        final responseBody = jsonDecode(response.body);
        String message = responseBody['message'] ?? 'Unknown error';

        // If 'data' exists in error, try decrypting it
        if (responseBody.containsKey('data')) {
          try {
            final decryptedError = ApiService.decryptData(responseBody['data']);
            final errorJson = jsonDecode(decryptedError);
            message = errorJson['message'] ?? message;
          } catch (_) {}
        }

        utils.showCustomSnackbar(message, false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      utils.showCustomSnackbar('Error: ${e.toString()}', false);
    }
  }

  Future<void> _resetPassword() async {
    if (passwordController.text != confirmPasswordController.text) {
      utils.showCustomSnackbar("Passwords do not match!", false);
      return;
    }
    setState(() => isLoading = true);

    try {
      final body = {
        "token": _resetToken,
        "newPassword": passwordController.text,
      };

      final encryptedBody = jsonEncode({"data": ApiService.encryptData(jsonEncode(body))});

      final url = Uri.parse("${ApiService.baseUrl}/Auth/resetPassword");
      final response = await http.post(
        url,
        body: encryptedBody,
        headers: {"Content-Type": "application/json"},
      );

      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final decryptedJson = ApiService.decryptData(responseBody['data']);
        final data = jsonDecode(decryptedJson);

        utils.showCustomSnackbar("Password reset successful!", true);
        Get.to(() => LogIn());

        setState(() {
          _isResetMode = false;
          emailController.clear();
          passwordController.clear();
          confirmPasswordController.clear();
        });
      } else {
        final responseBody = jsonDecode(response.body);
        String message = responseBody['message'] ?? 'Unknown error';

        if (responseBody.containsKey('data')) {
          try {
            final decryptedError = ApiService.decryptData(responseBody['data']);
            final errorJson = jsonDecode(decryptedError);
            message = errorJson['message'] ?? message;
          } catch (_) {}
        }

        utils.showCustomSnackbar(message, false);
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                // Logo
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
                const SizedBox(height: 32),

                // Headline
                Text(
                  _isResetMode ? AppString.resetPassword : AppString.forgotPassword,
                  style: TextStyleHelper.extraLargeWhite.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isResetMode ? AppString.enterNewPassword : AppString.enterEmailToReset,
                  style: TextStyleHelper.mediumWhite.copyWith(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Email field (auto send when typed)
                if (!_isResetMode)
                  _buildField(
                    controller: emailController,
                    hint: AppString.email,
                    icon: Icons.email_outlined,
                    inputType: TextInputType.emailAddress,
                    onChanged: _onEmailChanged,
                  ),

                // Reset fields
                if (_isResetMode) ...[
                  _buildField(
                    controller: passwordController,
                    hint: AppString.newPassword,
                    icon: Icons.lock_outline,
                    obscureText: !_isPasswordVisible,
                    suffix: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.primaryColour,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    controller: confirmPasswordController,
                    hint: AppString.confirmPassword,
                    icon: Icons.lock_outline,
                    obscureText: !_isConfirmPasswordVisible,
                    suffix: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.primaryColour,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _resetPassword,
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        backgroundColor: AppColors.primaryWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      )
                          : Text(
                        AppString.resetPassword,
                        style: TextStyleHelper.mediumBlack.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
Widget _buildField({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  bool obscureText = false,
  Widget? suffix,
  TextInputType inputType = TextInputType.text,
  void Function(String)? onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: obscureText,
      onChanged: onChanged,
      style: TextStyleHelper.mediumBlack,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: TextStyleHelper.mediumBlack.copyWith(
          color: Colors.black45,
        ),
        prefixIcon: Icon(icon, color: AppColors.primaryColour),
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

