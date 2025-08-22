import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../Library/ApiService.dart';
import '../../../Library/AppColour.dart';
import '../../../Library/AppStyle.dart';

class CustomerAnalyticsPage extends StatefulWidget {
  @override
  _CustomerAnalyticsPageState createState() => _CustomerAnalyticsPageState();
}

class _CustomerAnalyticsPageState extends State<CustomerAnalyticsPage> {
  bool isLoading = true;
  String errorMessage = '';
  Map<String, dynamic>? customerAnalytics;

  @override
  void initState() {
    super.initState();
    fetchCustomerAnalytics();
  }

  Future<void> fetchCustomerAnalytics() async {
    final String apiUrl = "${ApiService.baseUrl}/Report/getCustomerAnalytics";

    setState(() => isLoading = true);

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // The response body is expected to be encrypted string or JSON with encrypted "data" key

        final responseBody = json.decode(response.body);

        String decryptedJsonString;

        if (responseBody is String) {
          // If the API returns a raw encrypted string
          decryptedJsonString = ApiService.decryptData(responseBody);
        } else if (responseBody is Map<String, dynamic> && responseBody.containsKey('data')) {
          // If the API returns an object with encrypted data inside 'data' key
          decryptedJsonString = ApiService.decryptData(responseBody['data']);
        } else {
          // Unexpected format - fallback to original body as string
          decryptedJsonString = response.body;
        }

        final decryptedData = json.decode(decryptedJsonString);

        setState(() {
          customerAnalytics = decryptedData;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load analytics data.';
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColour,
        elevation: 0,
        title: Text(
          "Customer Analytics",
          style: TextStyleHelper.mediumPrimaryColour,
        ),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },color: AppColors.primaryColour, icon: Icon(Icons.arrow_back_ios_new_sharp),),

      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.secondaryColour))
          : errorMessage.isEmpty
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildKeyMetricsSection(),
              SizedBox(height: 20),
              _buildHighValueCustomersSection(),
            ],
          ),
        ),
      )
          : Center(
        child: Text(
          errorMessage,
          style: TextStyle(color: AppColors.secondaryColour, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildKeyMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text('Key Metrics',
        //     style: TextStyle(
        //         fontSize: 22,
        //         fontWeight: FontWeight.bold,
        //         color: Colors.deepOrangeAccent)),
        // SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildMetricCard('Total Customers', '${customerAnalytics?['totalCustomers']}')),
            SizedBox(width: 12),
            Expanded(child: _buildMetricCard('Average Orders', '${customerAnalytics?['averageOrdersPerCustomer']}')),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildMetricCard('Repeat Customers', '${customerAnalytics?['repeatCustomers']}')),
            SizedBox(width: 12),
            Expanded(child: _buildMetricCard('One-Time Customers', '${customerAnalytics?['oneTimeCustomers']}')),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColour,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14)),
          SizedBox(height: 8),
          Text(value,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
        ],
      ),
    );
  }

  Widget _buildHighValueCustomersSection() {
    final List<dynamic> highValueCustomers = customerAnalytics?['highValueCustomers'] ?? [];

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top 5 High-Value Customers',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColour)),
          SizedBox(height: 12),
          if (highValueCustomers.isEmpty)
            Center(
              child: Text('No high-value customer data available.',
                  style: TextStyle(color: Colors.grey)),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: highValueCustomers.length,
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (context, index) {
                final customer = highValueCustomers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryColour,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text('User ID: ${customer['userId']}',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('Orders: ${customer['orderCount']}'),
                );
              },
            ),
        ],
      ),
    );
  }
}
