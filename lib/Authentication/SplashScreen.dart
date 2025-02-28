import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Library/AppColour.dart';
import '../Library/AppImages.dart';
import '../Library/AppStrings.dart';
import '../Library/AppStyle.dart';
import '../Library/shared_pref_service.dart'; // Import SharedPrefService
import '../Dashboard/Dashboard.dart';
import 'AuthChoiceScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  Future<void> checkAuthentication() async {
    await Future.delayed(const Duration(seconds: 3)); // Reduce delay to 3 sec for better UX

    String? token = await SharedPrefService.getString('auth_token'); // Check if user is logged in

    if (token != null && token.isNotEmpty) {
      Get.off(() => DiamondHomePage(token: token)); // Redirect to Dashboard if logged in
    } else {
      Get.off(() => AuthChoiceScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppImages.splashImage, width: 150),
            const SizedBox(height: 20),
            Text(AppString.splash, style: TextStyleHelper.splashStyle),
          ],
        ),
      ),
    );
  }
}
