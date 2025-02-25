import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Dashboard/Dashboard.dart';
import '../Library/DiamondBackground.dart';
import '../Library/Utils.dart' as utils;

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);

    final String url = 'http://localhost:4000/api/user/login';
    final Map<String, String> headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> body = {
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
    };

    print("ssssssss ${url}");

    try {
      final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));

      print(response);
      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String token = responseData['token']; // Assuming API returns a token
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful!'), backgroundColor: Colors.green),
        );

        // Navigate to HomeScreen after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DiamondHomePage(token: token)),
        );
      } else {
        final errorMsg = jsonDecode(response.body)['message'] ?? 'Invalid credentials';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Unable to connect to server'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // DiamondBackground(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'LOG IN',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                utils.buildTextField('Email', _emailController),
                const SizedBox(height: 20),
                utils.buildTextField('Password', _passwordController, obscureText: true),
                const SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : utils.PrimaryButton(
                  text: 'Submit',
                  backgroundColor: Colors.green[100]!,
                  onPressed: _login,
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => print('Forgot password clicked'),
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.blue[200]!, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
