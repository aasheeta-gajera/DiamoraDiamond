
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:daimo/Library/SharedPrefService.dart';
import 'package:get/get.dart';
import '../Authentication/Login.dart';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class ApiService {

  static const String baseUrl = "https://1c61-157-32-244-183.ngrok-free.app/diamora/api";
  static String? userTypes = SharedPrefService.getString('userType') ?? "";

  static final _key = sha256.convert(utf8.encode('aasheeta#p')).bytes;

  static String encryptData(String plainText) {
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(
      encrypt.Key(Uint8List.fromList(_key)), //
      mode: encrypt.AESMode.cbc,
    ));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return iv.base16 + ':' + encrypted.base16;
  }

  static String decryptData(String encryptedText) {
    final parts = encryptedText.split(':');
    final iv = encrypt.IV.fromBase16(parts[0]);
    final encrypted = encrypt.Encrypted.fromBase16(parts[1]);

    final encrypter = encrypt.Encrypter(encrypt.AES(
      encrypt.Key(Uint8List.fromList(_key)), // <-- here
      mode: encrypt.AESMode.cbc,
    ));
    return encrypter.decrypt(encrypted, iv: iv);
  }

  static Future<Map<String, dynamic>> post(
      String endpoint,
      Map<String, dynamic> body,
      ) async {
    final encryptedBody = jsonEncode({"data": encryptData(jsonEncode(body))});
    print("Encrypted POST body: $encryptedBody");  // DEBUG
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: encryptedBody,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      final decrypted = decryptData(responseBody['data']);
      return jsonDecode(decrypted);
    } else {
      throw Exception('Error: ${response.statusCode} - ${response.body}');
    }
  }

  Future logout() async {
    await SharedPrefService.clearAll(); // Clear saved data
    Get.offAll(() => LogIn()); // Navigate back to login
  }

  void printLargeResponse(String response) {
    const int chunkSize = 1000; // Adjust chunk size as needed
    for (int i = 0; i < response.length; i += chunkSize) {
      print(response.substring(i, i + chunkSize > response.length ? response.length : i + chunkSize));
    }
  }

}

