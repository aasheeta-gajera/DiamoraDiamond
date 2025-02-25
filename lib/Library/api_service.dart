import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Models/UserModel.dart';

class ApiService {
  static const String baseUrl = "http://localhost:4000/api/user/register";

  static Future<bool> registerUser(UserModel user) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("User registered successfully");
        return true;
      } else {
        print("Errorrrrrrrrr: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }
}
