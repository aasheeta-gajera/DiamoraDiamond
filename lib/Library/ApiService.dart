
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:daimo/Library/SharedPrefService.dart';
import 'package:get/get.dart';
import '../Authentication/Login.dart';
import '../Models/DiamondModel.dart';

class ApiService {
  static const String baseUrl = "https://566f-2409-4080-9c9b-49b7-1b4-63ca-a710-aafa.ngrok-free.app/api/user";
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
}

