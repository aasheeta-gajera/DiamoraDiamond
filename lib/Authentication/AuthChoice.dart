
import 'package:flutter/material.dart';
import '../Library/AppColour.dart';
import '../Library/AppImages.dart';
import '../Library/AppStrings.dart';
import '../Library/AppStyle.dart';
import '../Library/Utils.dart' as utils;
import 'Login.dart';
import 'Registration.dart';
import 'package:get/get.dart';

class AuthChoiceScreen extends StatefulWidget {
  const AuthChoiceScreen({super.key});

  @override
  State<AuthChoiceScreen> createState() => _AuthChoiceScreenState();
}

class _AuthChoiceScreenState extends State<AuthChoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColour,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppImages.authChoice,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.width * 0.2,
                  left: MediaQuery.of(context).size.width * 0.1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.40,
                          child: Text(
                              AppString.authTxt,
                            style: TextStyleHelper.authChoiceStyle.copyWith(color: AppColors.primaryWhite)
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppString.authThough,
                          style: TextStyleHelper.textStyleMediam.copyWith(color: AppColors.primaryWhite)
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.width * 0.3,
                  left: MediaQuery.of(context).size.width * 0.1,
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: utils.PrimaryButton(
                          text: AppString.logIn,
                          backgroundColor: AppColors.primaryColour,
                          textColor: AppColors.primaryWhite,
                          borderColor: AppColors.primaryColour,
                          onPressed: () {
                            Get.to(() => LogIn());
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: utils.PrimaryButton(
                              text: AppString.register,
                              backgroundColor: AppColors.primaryWhite,
                              textColor: AppColors.primaryColour,
                              borderColor: AppColors.primaryWhite,
                              onPressed: () {
                                Get.to(() => Registration());
                              })),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
