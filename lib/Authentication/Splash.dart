
import 'package:daimo/Dashboard/Admin/AdminDashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Library/AppColour.dart';
import '../Library/AppImages.dart';
import '../Library/AppStrings.dart';
import '../Library/AppStyle.dart';
import '../Library/SharedPrefService.dart';
import '../Dashboard/User/CustomerDashboard.dart';
import 'AuthChoice.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<void> checkAuthentication() async {
    await Future.delayed(const Duration(seconds: 3));

    String? token = await SharedPrefService.getString('auth_token');
    String? userType = await SharedPrefService.getString('userType') ?? "";

    if (token != null && token.isNotEmpty) {
      if (userType == "admin") {
        Get.off(() => AdminDashboard(token: token)); // Navigate to Admin Dashboard
      } else {
        Get.off(() => CustomerDashboard(token: token)); // Navigate to User Dashboard
      }
    } else {
      Get.off(() => AuthChoiceScreen());
    }
  }


  @override
  void initState() {
    super.initState();
    checkAuthentication();
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
