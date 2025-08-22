import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../Library/ApiService.dart';
import '../../Library/AppColour.dart';
import '../../Library/AppStrings.dart';
import '../../Library/AppStyle.dart';
import '../../Library/Utils.dart' as utils;
import '../../Models/InquiryModel.dart';

class AdminInquiryScreen extends StatefulWidget {
  final String adminName;

  const AdminInquiryScreen({Key? key, required this.adminName})
    : super(key: key);

  @override
  _AdminInquiryScreenState createState() => _AdminInquiryScreenState();
}

class _AdminInquiryScreenState extends State<AdminInquiryScreen> {
  List<InquiryModel> inquiries = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchInquiries();
  }

  Future<void> fetchInquiries() async {
    final String apiUrl = "${ApiService.baseUrl}/Admin/inquiries";
    final url = Uri.parse(apiUrl);

    setState(() => loading = true);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        // If API returns encrypted string directly
        if (responseBody is String) {
          final decryptedJsonString = ApiService.decryptData(responseBody);
          final decryptedData = json.decode(decryptedJsonString);

          if (decryptedData is List) {
            setState(() {
              inquiries = decryptedData
                  .map((json) => InquiryModel.fromJson(json))
                  .toList();
              loading = false;
            });
          } else {
            print("Unexpected decrypted data format: $decryptedData");
            setState(() => loading = false);
          }

          // If API returns a list directly (already decrypted)
        } else if (responseBody is List) {
          setState(() {
            inquiries = responseBody
                .map((json) => InquiryModel.fromJson(json))
                .toList();
            loading = false;
          });

          // If API returns an object (probably encrypted under 'data' key)
        } else if (responseBody is Map<String, dynamic> && responseBody.containsKey('data')) {
          final encryptedData = responseBody['data'] as String;
          final decryptedJsonString = ApiService.decryptData(encryptedData);
          final decryptedData = json.decode(decryptedJsonString);

          if (decryptedData is List) {
            setState(() {
              inquiries = decryptedData
                  .map((json) => InquiryModel.fromJson(json))
                  .toList();
              loading = false;
            });
          } else {
            print("Unexpected decrypted data format inside 'data' key: $decryptedData");
            setState(() => loading = false);
          }

        } else {
          print("Unexpected API format: $responseBody");
          setState(() => loading = false);
        }

      } else {
        final errorMsg = jsonDecode(response.body)['message'] ?? 'Failed to fetch inquiries';
        utils.showCustomSnackbar(errorMsg, false);
        setState(() => loading = false);
      }
    } catch (e) {
      setState(() => loading = false);
      utils.showCustomSnackbar('Error: $e', false);
    }
  }

  Future<void> respondToInquiry(String id) async {
    TextEditingController responseController = TextEditingController();
    final String apiUrl = "${ApiService.baseUrl}/Admin/inquiry/$id/respond";

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Respond to Inquiry'),
        content: TextField(
          controller: responseController,
          maxLines: 3,
          decoration: InputDecoration(hintText: "Type your response here"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final url = Uri.parse(apiUrl);

              final body = json.encode({
                'response': responseController.text,
                'adminName': widget.adminName,
              });

              final headers = {'Content-Type': 'application/json'};

              final res = await http.post(
                url,
                body: body,
                headers: headers,
              );

              if (res.statusCode == 200) {
                Navigator.pop(context);
                fetchInquiries(); // Refresh list
                utils.showCustomSnackbar("Response sent successfully", true);
              } else {
                final resBody = jsonDecode(res.body);
                utils.showCustomSnackbar(resBody['message'] ?? "Failed to respond", false);
                print("Failed to respond: ${res.body}");
              }
            },
            child: Text("Send"),
          ),
        ],
      ),
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
          icon: const Icon(Icons.arrow_back_ios_new_sharp, color: AppColors.primaryColour),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primaryColour, AppColors.secondaryColour],
            ),
          ),
          child:
              loading
                  ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryWhite,
                    ),
                  )
                  : inquiries.isEmpty
                  ? Center(
                    child: Text(
                      AppString.noDataFound,
                      style: TextStyleHelper.mediumWhite,
                    ),
                  )
                  : ListView.builder(
                    itemCount: inquiries.length,
                    itemBuilder: (context, index) {
                      final inquiry = inquiries[index]; // now InquiryModel type
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(inquiry.subject ?? "No Subject"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Message: ${inquiry.message}"),
                              Text("Status: ${inquiry.status}"),
                              if (inquiry.response != null)
                                Text("Response: ${inquiry.response}"),
                              if (inquiry.respondedBy != null)
                                Text("Responded by: ${inquiry.respondedBy}"),
                            ],
                          ),
                          trailing:
                              inquiry.status != 'responded'
                                  ? IconButton(
                                    icon: Icon(Icons.reply),
                                    onPressed:
                                        () => respondToInquiry(inquiry.id),
                                  )
                                  : null,
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }
}
