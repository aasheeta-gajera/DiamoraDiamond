
import 'package:flutter/material.dart';
import 'AppColour.dart';
import 'package:get/get.dart';

Widget PrimaryButton({
  required String text,
  required VoidCallback onPressed,
  Color backgroundColor = AppColors.primaryBlack,
  Color textColor = AppColors.primaryWhite,
  Color borderColor = Colors.transparent,
  double width = double.infinity,
}) {
  return SizedBox(
    width: width,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: borderColor),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 16),
      ),
    ),
  );
}

Widget PrimaryTextField({
  required String label,
  required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  bool obscureText = false,
  Color? borderColor,
  Color? fillColor,
  double? borderRadius,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 5),
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor ??AppColors.primaryWhite, // Default: White background
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12), // Default: 12
            borderSide: BorderSide(color: borderColor ?? Colors.grey), // Default: Grey border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
            borderSide: BorderSide(color: borderColor ?? Colors.blue, width: 2), // Default: Blue focus
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
            borderSide: BorderSide(color: borderColor ?? Colors.grey),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    ],
  );
}

void showCustomSnackbar(String message, bool isSuccess) {
  Get.snackbar(
    isSuccess ? 'Success' : 'Error',
    message,
    backgroundColor: isSuccess ? Colors.green : Colors.red,
    colorText: AppColors.primaryWhite,
    snackPosition: SnackPosition.BOTTOM,
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    borderRadius: 8,
    duration: const Duration(seconds: 3),
    // overlayBlur: 1,
  );
}

Widget buildTextField(
    String label,
    TextEditingController controller,
    {bool obscureText = false, IconData? icon, required Color textColor, required MaterialColor hintColor,onChange}) {

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      onChanged: onChange,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: AppColors.primaryBlack) : null,
        filled: true,
        fillColor: AppColors.primaryWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryBlack, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      validator: (value) => value!.isEmpty ? "$label is required" : null,
    ),
  );
}