import 'package:flutter/material.dart';
import 'AppColour.dart';

Widget PrimaryButton({
  required String text,
  required VoidCallback onPressed,
  Color backgroundColor = AppColors.buttonPrimary,
  Color textColor = AppColors.buttonTextPrimary,
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
          fillColor: fillColor ?? Colors.white, // Default: White background
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


Widget buildTextField(
    String label,
    TextEditingController controller,
    {bool obscureText = false, IconData? icon}) {

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon, color: Colors.blueAccent) : null,
        filled: true,
        fillColor: Colors.white,
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
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
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