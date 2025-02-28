
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:daimo/Library/shared_pref_service.dart';
import 'package:get/get.dart';
import '../Authentication/LoginScreen.dart';
import '../Models/diamond_model.dart';

class ApiService {
  static const String baseUrl = "https://837a-2402-8100-26a2-c430-9d54-6f33-dae6-4dd6.ngrok-free.app/api/user";

  Future logout() async {
    await SharedPrefService.clearAll(); // Clear saved data
    Get.offAll(() => Loginscreen());   // Navigate back to login
  }

  Future<List<Diamond>> fetchDiamonds() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> diamondList = data['diamonds'];

      return diamondList.map((json) => Diamond.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load diamonds");
    }
  }
}

