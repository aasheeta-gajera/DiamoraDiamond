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
    final String apiUrl = "${ApiService.baseUrl}/admin/inquiries";

    final url = Uri.parse(apiUrl);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          inquiries = data.map((json) => InquiryModel.fromJson(json)).toList();
          loading = false;
        });
      } else {
        utils.showCustomSnackbar(jsonDecode(response.body)['message'], false);
      }
    } catch (e) {
      setState(() => loading = false);
      utils.showCustomSnackbar('${e}', false);
    }
  }

  Future<void> respondToInquiry(String id) async {
    TextEditingController responseController = TextEditingController();

    final String apiUrl = "${ApiService.baseUrl}/admin/inquiry/$id/respond";

    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
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
                    fetchInquiries(); // refresh list
                  } else {
                    print("Failed to respond");
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
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryColour),
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
