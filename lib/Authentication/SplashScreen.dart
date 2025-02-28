
import 'package:daimo/Library/AppColour.dart';
import 'package:daimo/Library/AppImages.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import '../Library/AppStrings.dart';
import '../Library/AppStyle.dart';
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
    Future.delayed(const Duration(seconds: 10), () {
      Get.to(() => AuthChoiceScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      body: Stack(
        children: [
          Positioned(
            top: 200,
            left: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.splashImage,
                  width: 150,
                ),
                const SizedBox(height: 20),
                Text(
                  AppString.splash,
                  style: TextStyleHelper.splashStyle
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
