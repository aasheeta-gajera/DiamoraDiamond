import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Library/ApiService.dart';
import '../../Library/SharedPrefService.dart';

class InquiryScreen extends StatefulWidget {
  @override
  State<InquiryScreen> createState() => _InquiryScreenState();
}

class _InquiryScreenState extends State<InquiryScreen> {
  final _formKey = GlobalKey<FormState>();
  final subjectController = TextEditingController();
  final messageController = TextEditingController();
  final diamondIdController = TextEditingController();
  final diamondShapeController = TextEditingController();
  final caratWeightController = TextEditingController();
  final colorController = TextEditingController();
  final clarityController = TextEditingController();
  final certificationController = TextEditingController();

  bool _isLoading = false;

  Future<void> submitInquiry() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final url = Uri.parse('${ApiService.baseUrl}/inquiry'); // Replace with your live/local endpoint
    final userId = await SharedPrefService.getString('userId') ?? '';

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userId": userId,
        "subject": subjectController.text,
        "message": messageController.text,
        "diamondId": diamondIdController.text,
        "diamondShape": diamondShapeController.text,
        "caratWeight": caratWeightController.text,
        "color": colorController.text,
        "clarity": clarityController.text,
        "certification": certificationController.text,
      }),
    );

    setState(() => _isLoading = false);

    final data = jsonDecode(response.body);
    if (response.statusCode == 201) {
      Get.snackbar("Success", "Inquiry submitted successfully",
          backgroundColor: Colors.green, colorText: Colors.white);
      _formKey.currentState!.reset();
    } else {
      Get.snackbar("Error", data['error'] ?? 'Something went wrong',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Inquiry")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Subject", subjectController),
              _buildTextField("Message", messageController),
              _buildTextField("Diamond ID", diamondIdController),
              _buildTextField("Diamond Shape", diamondShapeController),
              _buildTextField("Carat Weight", caratWeightController),
              _buildTextField("Color", colorController),
              _buildTextField("Clarity", clarityController),
              _buildTextField("Certification", certificationController),
              const SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                  onPressed: submitInquiry, child: Text("Submit Inquiry")),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
      ),
    );
  }
}
