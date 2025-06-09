import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../Library/ApiService.dart';
import '../../../Library/AppColour.dart';
import '../../../Library/AppStyle.dart';

class InventoryAnalyticsPage extends StatefulWidget {
  @override
  _InventoryAnalyticsPageState createState() => _InventoryAnalyticsPageState();
}

class _InventoryAnalyticsPageState extends State<InventoryAnalyticsPage> {
  bool isLoading = true;
  String errorMessage = '';
  Map<String, dynamic>? inventoryAnalytics;

  @override
  void initState() {
    super.initState();
    fetchInventoryAnalytics();
  }

  Future<void> fetchInventoryAnalytics() async {
    final String apiUrl = "${ApiService.baseUrl}/Report/getInventoryAnalytics";

    setState(() => isLoading = true);

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        String decryptedJsonString;

        if (responseBody is String) {
          // Raw encrypted string response
          decryptedJsonString = ApiService.decryptData(responseBody);
        } else if (responseBody is Map<String, dynamic> && responseBody.containsKey('data')) {
          // Encrypted data inside 'data' key
          decryptedJsonString = ApiService.decryptData(responseBody['data']);
        } else {
          // Unexpected format, fallback to original body
          decryptedJsonString = response.body;
        }

        final decryptedData = json.decode(decryptedJsonString);

        setState(() {
          inventoryAnalytics = decryptedData;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load inventory data.';
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
    final colors = {
      'primary': AppColors.secondaryColour,
      'secondary': AppColors.secondaryColour,
      'bg': Color(0xFFFDF4F0),
    };

    return Scaffold(
      backgroundColor: colors['bg'],
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColour,
        elevation: 0,
        title: Text(
          "Inventory Analytics",
          style: TextStyleHelper.mediumPrimaryColour,
        ),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },color: AppColors.primaryColour, icon: Icon(Icons.arrow_back_ios_new_sharp),),

      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage, style: TextStyle(color: AppColors.secondaryColour)))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildChatBubble("Here's your inventory snapshot", colors),
              SizedBox(height: 10),
              _buildKeyMetricsSection(colors),
              SizedBox(height: 20),
              _buildInventoryPieChart(colors),
              SizedBox(height: 20),
              _buildFastSellingItems(colors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatBubble(String message, Map<String, Color> colors) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors['primary'],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(message, style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildKeyMetricsSection(Map<String, Color> colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildMetricCard('Total', '${inventoryAnalytics?['totalInventory']}', colors),
        _buildMetricCard('In Stock', '${inventoryAnalytics?['inStock']}', colors),
        _buildMetricCard('Out of Stock', '${inventoryAnalytics?['outOfStock']}', colors),
        _buildMetricCard('Low Stock', '${(inventoryAnalytics?['lowStockItems'] as List).length}', colors),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, Map<String, Color> colors) {
    return Expanded(
      child: Card(
        color: colors['secondary'],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        // elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(value, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInventoryPieChart(Map<String, Color> colors) {
    int inStock = inventoryAnalytics?['inStock'] ?? 0;
    int outOfStock = inventoryAnalytics?['outOfStock'] ?? 0;
    int lowStock = (inventoryAnalytics?['lowStockItems'] as List).length;

    List<_ChartData> chartData = [
      _ChartData('In Stock', inStock, AppColors.secondaryColour),
      _ChartData('Out of Stock', outOfStock, AppColors.primaryColour),
      _ChartData('Low Stock', lowStock, AppColors.primaryShadow),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChatBubble("Visual breakdown", colors),
        SizedBox(height: 10),
        SfCircularChart(
          legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
          series: <CircularSeries>[
            PieSeries<_ChartData, String>(
              dataSource: chartData,
              xValueMapper: (_ChartData data, _) => data.category,
              yValueMapper: (_ChartData data, _) => data.value,
              pointColorMapper: (_ChartData data, _) => data.color,
              dataLabelMapper: (_ChartData data, _) => '${data.value}',
              dataLabelSettings: DataLabelSettings(isVisible: true),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildFastSellingItems(Map<String, Color> colors) {
    List<dynamic> items = inventoryAnalytics?['fastSellingItems'] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChatBubble("Top fast-selling items 🚀", colors),
        SizedBox(height: 10),
        ...items.map((item) {
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: ListTile(
              leading: Icon(Icons.local_offer, color: colors['primary']),
              title: Text(item['name']),
              subtitle: Text('Sold Count: ${item['soldCount']}'),
            ),
          );
        }).toList(),
      ],
    );
  }
}

class _ChartData {
  _ChartData(this.category, this.value, this.color);
  final String category;
  final int value;
  final Color color;
}
