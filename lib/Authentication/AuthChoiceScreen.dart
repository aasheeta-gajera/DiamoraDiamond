import 'package:flutter/material.dart';
import '../Library/AppColour.dart';
import '../Library/DiamondBackground.dart';
import '../Library/Utils.dart' as utils;
import 'LoginScreen.dart';
import 'Registration.dart';

class AuthChoiceScreen extends StatefulWidget {
  const AuthChoiceScreen({super.key});

  @override
  State<AuthChoiceScreen> createState() => _AuthChoiceScreenState();
}

class _AuthChoiceScreenState extends State<AuthChoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // DiamondBackground(),
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
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: const Text(
                            "My Jewelry",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlack,
                              fontFamily: 'Serif',
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "find your dream Diamond",
                          style: TextStyle(
                            fontSize: 14, // Small subtitle text
                            color: AppColors.primaryBlack,
                          ),
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
                          text: 'LOGIN',
                          backgroundColor:  Colors.blue[50]!,
                          textColor:  Colors.purple[200]!,
                          borderColor: Colors.blue[50]!,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Loginscreen(),
                                ));
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: utils.PrimaryButton(
                              text: 'REGISTER',
                              backgroundColor:  Colors.green[50]!,
                              textColor:  Colors.purple[200]!,
                              borderColor: Colors.blue[50]!,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegistrationScreen(),
                                    ));
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
