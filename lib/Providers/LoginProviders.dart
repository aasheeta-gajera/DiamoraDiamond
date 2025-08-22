import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../Dashboard/Admin/AdminDashboard.dart';
import '../Dashboard/User/CustomerDashboard.dart';
import '../Library/ApiService.dart';
import '../Library/SharedPrefService.dart';
import '../Library/Utils.dart' as utils;

class LoginProvider extends ChangeNotifier{
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  bool isPass () => _isPasswordVisible;

  set isPasswordVisible(bool value) {
    _isPasswordVisible = value;
    notifyListeners();
  }
  bool isLoad () => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    String? token = SharedPrefService.getString('auth_token');
    String? userTypes = await SharedPrefService.getString('userType') ?? "";

    if (token != null && token.isNotEmpty) {
      if (userTypes == "admin") {
        Get.off(() => AdminDashboard(token: token));
        notifyListeners();
      } else {
        Get.off(() => CustomerDashboard(token: token));
        notifyListeners();
      }
    }
  }

  Future<void> _login() async {
    _isLoading = true;

    final Map<String, dynamic> body = {
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
    };

    try {
      final responseData = await ApiService.post('/Auth/login', body);
      _isLoading= false;

      String token = responseData['token'] ?? '';
      String email = responseData['user']['email'] ?? '';
      String name = responseData['user']['name'] ?? '';
      String userId = responseData['user']['_id'] ?? '';
      String mobile = responseData['user']['mobile'] ?? '';
      String city = responseData['user']['city'] ?? '';
      String address = responseData['user']['address'] ?? '';
      String contactName = responseData['user']['contact_name'] ?? '';
      String idProof = responseData['user']['idProof'] ?? '';
      String licenseCopy = responseData['user']['licenseCopy'] ?? '';
      String taxCertificate = responseData['user']['taxCertificate'] ?? '';
      String partnerCopy = responseData['user']['partnerCopy'] ?? '';
      String userType = responseData['user']['userType'] ?? '';

      // Save User Data
      await SharedPrefService.setString('auth_token', token);
      await SharedPrefService.setString('user_email', email);
      await SharedPrefService.setString('user_name', name);
      await SharedPrefService.setString('userId', userId);
      await SharedPrefService.setString('mobileNo', mobile);
      await SharedPrefService.setString('Address', address);
      await SharedPrefService.setString('contactName', contactName);
      await SharedPrefService.setString('City', city);
      await SharedPrefService.setString('id_proof', idProof);
      await SharedPrefService.setString('license_copy', licenseCopy);
      await SharedPrefService.setString('tax_certificate', taxCertificate);
      await SharedPrefService.setString('partner_copy', partnerCopy);
      await SharedPrefService.setString('userType', userType);

      utils.showCustomSnackbar('Login successful!', true);

      if (userType == "admin") {
        Get.off(() => AdminDashboard(token: token));
      } else {
        Get.off(() => CustomerDashboard(token: token));
      }
    } catch (e) {
      _isLoading = false;
      print(e.toString());
      utils.showCustomSnackbar('Error: ${e.toString()}', false);
    }
  }

  void logIn () => _login();

}