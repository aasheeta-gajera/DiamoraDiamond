import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Library/ApiService.dart';
import '../../Library/AppColour.dart';
import '../../Library/AppStrings.dart';
import '../../Library/AppStyle.dart';
import '../../Library/SharedPrefService.dart';
import '../../Library/Utils.dart' as utils;
import '../../Models/InquiryModel.dart';

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

  // To keep track of the inquiries after submission
  List<InquiryModel> inquiries = [];

  Future<void> submitInquiry() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final userId = await SharedPrefService.getString('userId') ?? '';

    final newInquiry = InquiryModel(
      userId: userId,
      subject: subjectController.text,
      message: messageController.text,
      diamondId: diamondIdController.text,
      diamondShape: diamondShapeController.text,
      caratWeight: caratWeightController.text,
      color: colorController.text,
      clarity: clarityController.text,
      certification: certificationController.text, id: '',
    );

    final url = Uri.parse('${ApiService.baseUrl}/Admin/inquiry');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(newInquiry.toJson()),
    );

    setState(() => _isLoading = false);

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      Get.snackbar("Success", "Inquiry submitted successfully",
          backgroundColor: Colors.green, colorText: Colors.white);
      _formKey.currentState!.reset();

      // Optionally add the newly created inquiry to the list
      inquiries.add(InquiryModel.fromJson(data));
      setState(() {}); // Refresh UI if necessary
    } else {
      Get.snackbar("Error", data['error'] ?? 'Something went wrong',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> fetchInquiries() async {
    final String apiUrl = "${ApiService.baseUrl}/Admin/inquiries";

    final url = Uri.parse(apiUrl);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          inquiries = data.map((json) => InquiryModel.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        utils.showCustomSnackbar(jsonDecode(response.body)['message'], false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      utils.showCustomSnackbar('${e}', false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchInquiries(); // Fetch on screen load
  }

  void _showAllInquiriesBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (_, controller) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Inquiries',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: inquiries.isEmpty
                      ? Center(child: Text('No inquiries submitted yet.'))
                      : ListView.builder(
                    controller: controller,
                    itemCount: inquiries.length,
                    itemBuilder: (context, index) {
                      final inquiry = inquiries[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text('Subject: ${inquiry.subject}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Message: ${inquiry.message}'),
                              Text('Status: ${inquiry.status}'),
                              Text('Response: ${inquiry.response ?? 'No response yet'}'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColour,
        elevation: 1,
        title: Text(
          AppString.inquiry,
          style: TextStyleHelper.mediumPrimaryColour,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.primaryColour,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.history, color: AppColors.primaryColour),
            onPressed: () {
              _showAllInquiriesBottomSheet();
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryColour, AppColors.secondaryColour],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                utils.buildTextField(
                  "Subject",
                  subjectController,
                  textColor: AppColors.primaryWhite,
                  hintColor: Colors.grey,
                ),
                utils.buildTextField(
                  "Message",
                  messageController,
                  textColor: AppColors.primaryWhite,
                  hintColor: Colors.grey,
                ),
                utils.buildTextField(
                  "Diamond ID",
                  diamondIdController,
                  textColor: AppColors.primaryWhite,
                  hintColor: Colors.grey,
                ),
                utils.buildTextField(
                  "Diamond Shape",
                  diamondShapeController,
                  textColor: AppColors.primaryWhite,
                  hintColor: Colors.grey,
                ),
                utils.buildTextField(
                  "Carat Weight",
                  caratWeightController,
                  textColor: AppColors.primaryWhite,
                  hintColor: Colors.grey,
                ),
                utils.buildTextField(
                  "Color",
                  colorController,
                  textColor: AppColors.primaryWhite,
                  hintColor: Colors.grey,
                ),
                utils.buildTextField(
                  "Clarity",
                  clarityController,
                  textColor: AppColors.primaryWhite,
                  hintColor: Colors.grey,
                ),
                utils.buildTextField(
                  "Certification",
                  certificationController,
                  textColor: AppColors.primaryWhite,
                  hintColor: Colors.grey,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator(
                  color: AppColors.primaryWhite,
                )
                    : utils.PrimaryButton(
                  text: "Submit Inquiry",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      submitInquiry();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
