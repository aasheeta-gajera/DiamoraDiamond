
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Library/AppColour.dart';
import '../Library/AppImages.dart';
import '../Library/AppStrings.dart';
import '../Library/AppStyle.dart';
import 'Login.dart';
import 'Registration.dart';

class AuthChoice extends StatelessWidget {
  const AuthChoice({super.key});

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
          child: Column(
            children: [
              const SizedBox(height: 60),

              // Logo with blur background effect
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

              // Title
              Text(
                AppString.welcomeToDaimo,
                style: TextStyleHelper.extraLargeWhite.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              // Tagline
              Text(
                "Your Sparkle Starts Here 💎",
                style: TextStyleHelper.mediumWhite.copyWith(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.4,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    // Login Button
                    ElevatedButton(
                      onPressed: () => Get.to(() => const LogIn()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryWhite,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 6,
                        shadowColor: AppColors.cardShadow,
                      ),
                      child: Text(
                        AppString.logIn,
                        style: TextStyleHelper.mediumBlack.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Register Button with semi-transparent background
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColour.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.primaryWhite,
                          width: 1.5,
                        ),
                      ),
                      child: TextButton(
                        onPressed: () => Get.to(() => const Registration()),
                        child: Text(
                          AppString.register,
                          style: TextStyleHelper.mediumWhite.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
