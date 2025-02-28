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
import '../Library/shared_pref_service.dart';  // Import the shared preferences service
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

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    String? token = SharedPrefService.getString('auth_token');

    if (token != null && token.isNotEmpty) {
      Get.off(() => DiamondHomePage(token: token));
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
      final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));
      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String token = responseData['token']??'';
        String email = responseData['user']['email']??'';
        String name = responseData['user']['name']??'';
        String userId = responseData['user']['user_id']??'';
        String mobile = responseData['user']['mobile']??'';
        String city = responseData['user']['city']??'';
        String address = responseData['user']['address']??'';
        String contactName = responseData['user']['contact_name']??'';
        String idProof = responseData['user']['idProof']??'';
        String licenseCopy = responseData['user']['licenseCopy']??'';
        String taxCertificate = responseData['user']['taxCertificate']??'';
        String partnerCopy = responseData['user']['partnerCopy']??'';

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


        utils.showCustomSnackbar('Login successful!', true);
        Get.off(() => DiamondHomePage(token: token));

      } else {
        utils.showCustomSnackbar(jsonDecode(response.body)['message'] ?? 'Invalid credentials', false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      print(e);
      utils.showCustomSnackbar('${e}', false);
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
                onTap: () => Get.to(ForgotResetPasswordScreen()),
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
