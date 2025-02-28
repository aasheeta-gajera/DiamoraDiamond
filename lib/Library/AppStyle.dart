import 'package:flutter/material.dart';

import 'AppColour.dart';

class TextStyleHelper {
  // 🔹 Small Text Style
  static TextStyle smallBlack = const TextStyle(
    fontSize: 12,
    color: AppColors.primaryBlack, // Black text for light mode
  );

  static TextStyle smallWhite = const TextStyle(
    fontSize: 12,
    color: AppColors.primaryWhite, // White text for dark mode
  );

  // 🔹 Medium Text Style
  static TextStyle mediumBlack = const TextStyle(
    fontSize: 16,
    color: AppColors.primaryBlack,
  );

  static TextStyle mediumWhite = const TextStyle(
    fontSize: 16,
    color: AppColors.primaryWhite,
  );

  // 🔹 Big Text Style
  static TextStyle bigBlack = const TextStyle(
    fontSize: 20,
    color: AppColors.primaryBlack,
  );

  static TextStyle bigWhite = const TextStyle(
    fontSize: 20,
    color: AppColors.primaryWhite,
  );

  // 🔹 Extra Large Text Style
  static TextStyle extraLargeBlack = const TextStyle(
    fontSize: 24,
    color: AppColors.primaryBlack,
  );

  static TextStyle extraLargeWhite = const TextStyle(
    fontSize: 24,

    color: AppColors.primaryWhite,
  );

  static TextStyle splashStyle = TextStyle(
    color: AppColors.primaryBlack,
    fontSize: 18,
  );

  static TextStyle authChoiceStyle = TextStyle(
    fontSize: 32,
    color: AppColors.primaryWhite,
    fontFamily: 'Serif',
  );

  static TextStyle textStyleMediam = TextStyle(
    fontSize: 14,
    color: AppColors.primaryWhite,
  );
}
