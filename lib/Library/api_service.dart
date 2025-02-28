import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Models/UserModel.dart';

class ApiService {
  static const String baseUrl = "https://ad81-2409-4080-9c9b-49b7-c54a-ce8e-32f0-202b.ngrok-free.app/api/user";

  static Future<bool> registerUser(UserModel user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("User registered successfully");
        return true;
      } else {
        print("Error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }
}
