
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:daimo/Library/SharedPrefService.dart';
import 'package:get/get.dart';
import '../Authentication/Login.dart';
import '../Models/DiamondModel.dart';

class ApiService {
  static const String baseUrl = "https://7a60-2402-3a80-4528-c19a-dc7a-5706-2c96-20a9.ngrok-free.app/api/user";
  static String? userTypes = SharedPrefService.getString('userType') ?? "";

  Future logout() async {
    await SharedPrefService.clearAll(); // Clear saved data
    Get.offAll(() => LogIn());   // Navigate back to login
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

