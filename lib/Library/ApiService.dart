
import 'dart:convert';
import 'package:daimo/Authentication/AuthChoice.dart';
import 'package:http/http.dart' as http;
import 'package:daimo/Library/SharedPrefService.dart';
import 'package:get/get.dart';
import '../Authentication/Login.dart';
import '../Models/DiamondModel.dart';

class ApiService {
  static const String baseUrl = "https://84ac-2409-4080-be18-c956-e8b6-22d9-b9a3-424f.ngrok-free.app/api/user";
  static String? userTypes = SharedPrefService.getString('userType') ?? "";

  Future logout() async {
    await SharedPrefService.clearAll(); // Clear saved data
    Get.offAll(() => AuthChoiceScreen());   // Navigate back to login
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

  void printLargeResponse(String response) {
    const int chunkSize = 1000; // Adjust chunk size as needed
    for (int i = 0; i < response.length; i += chunkSize) {
      print(response.substring(i, i + chunkSize > response.length ? response.length : i + chunkSize));
    }
  }

}

