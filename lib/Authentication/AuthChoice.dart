
import 'package:flutter/material.dart';
import '../Library/AppColour.dart';
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
      backgroundColor: AppColors.primaryWhite,
      body: Stack(
        children: [
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
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Text(
                              AppString.authTxt,
                            style: TextStyleHelper.authChoiceStyle.copyWith(color: AppColors.primaryBlack)
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppString.authThough,
                          style: TextStyleHelper.textStyleMediam.copyWith(color: AppColors.primaryBlack)
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: MediaQuery.of(context).size.width * 0.2,
                  left: MediaQuery.of(context).size.width * 0.1,
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: utils.PrimaryButton(
                          text: AppString.logIn,
                          backgroundColor: AppColors.primaryBlack,
                          textColor: AppColors.primaryWhite,
                          borderColor: AppColors.primaryBlack,
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
                              backgroundColor: AppColors.primaryBlack,
                              textColor: AppColors.primaryWhite,
                              borderColor: AppColors.primaryBlack,
                              onPressed: () {
                                Get.to(() => RegistrationScreen());
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
