import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../Library/ApiService.dart';
import '../../Library/AppColour.dart';
import '../../Library/AppStyle.dart';
import '../../Library/Utils.dart' as utils;

class InvoiceScreen extends StatefulWidget {
  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  List<Map<String, dynamic>> invoices = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchInvoices();
  }

  Future<void> fetchInvoices() async {
    try {
      final response = await http.get(
        Uri.parse("https://e7b9-146-70-246-124.ngrok-free.app/diamora/api/Customer/getAllInvoices"),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody.containsKey("invoices")) {
          setState(() {
            invoices = List<Map<String, dynamic>>.from(responseBody["invoices"]);
            loading = false;
          });
        } else {
          throw Exception("Missing 'invoices' key");
        }
      } else {
        throw Exception("HTTP ${response.statusCode}");
      }
    } catch (e) {
      print("Fetch Error: $e");
      setState(() => loading = false);
      utils.showCustomSnackbar("Error loading invoices", false);
    }
  }

  Future<void> openInvoice(String relativeUrl) async {
    final fullUrl = "https://apisdiamora.onrender.com$relativeUrl".replaceAll("\\", "/");
    final uri = Uri.parse(fullUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      utils.showCustomSnackbar("Could not open invoice PDF", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColour,
        elevation: 0,
        title: Text("Invoices", style: TextStyleHelper.mediumPrimaryColour),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.primaryColour),
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : invoices.isEmpty
          ? Center(child: Text("No invoices found"))
          : ListView.builder(
        itemCount: invoices.length,
        itemBuilder: (context, index) {
          final invoice = invoices[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              onTap: () => openInvoice(invoice['url']),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf, color: AppColors.primaryColour, size: 28),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        invoice['fileName'] ?? 'Unnamed Invoice',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColour,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      )
    );
  }
}
