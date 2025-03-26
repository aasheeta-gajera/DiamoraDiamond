
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
    TextEditingController controller, {
      bool obscureText = false,
      IconData? icon,
      Color? textColor, // Removed required, now optional
      Color? hintColor, // Removed required, now optional
      bool readOnly = false,
      String? Function(String?)? validator,
      TextInputType keyboardType = TextInputType.text,
      Function(String)? onChange,
    }) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      onChanged: onChange,
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      // style: TextStyle(color: textColor), // Optional text color
      decoration: InputDecoration(
        labelText: label,
        hintText: label,
        labelStyle: const TextStyle(color: Colors.white), // Set label text color to white
        hintStyle: TextStyle(color: hintColor), // Optional hint color
        prefixIcon: icon != null ? Icon(icon, color: Colors.white) : null, // Black icon
        filled: true,
        fillColor: Colors.transparent, // No default background color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white), // Black border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 2), // Black border on focus
        ),
      ),
    ),
  );
}


Widget buildDropdownField({
  required String label,
  required String? value,
  required List<Map<String, String>> items,
  required Function(String?) onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white), // Set label color to white
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryWhite),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryWhite, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      dropdownColor: Colors.black,
      value: value,
      items: items.map((supplier) {
        return DropdownMenuItem<String>(
          value: supplier["supplier"],
          child: Text(supplier["supplier"]!),
        );
      }).toList(),
      style: TextStyle(color: Colors.white), // Dropdown text color
      onChanged: onChanged,
    ),
  );
}

