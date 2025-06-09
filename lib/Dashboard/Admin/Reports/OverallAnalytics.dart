import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../../../Library/ApiService.dart';
import '../../../Library/AppColour.dart';
import '../../../Library/AppStyle.dart';

class AnalyticsDashboardPage extends StatefulWidget {
  @override
  _AnalyticsDashboardPageState createState() => _AnalyticsDashboardPageState();
}

class _AnalyticsDashboardPageState extends State<AnalyticsDashboardPage> {
  Map<String, dynamic>? analyticsData;
  bool isLoading = true;
  String errorMessage = '';
  late List<ChartData> salesData;

  @override
  void initState() {
    super.initState();
    salesData = [];
    fetchAnalytics();
  }

  Future<void> fetchAnalytics() async {
    final String apiUrl = "${ApiService.baseUrl}/Report/getOverallAnalytics";

    setState(() => isLoading = true);

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        String decryptedJsonString;

        if (responseBody is String) {
          // If response is encrypted string directly
          decryptedJsonString = ApiService.decryptData(responseBody);
        } else if (responseBody is Map<String, dynamic> && responseBody.containsKey('data')) {
          // If encrypted data is inside 'data' key
          decryptedJsonString = ApiService.decryptData(responseBody['data']);
        } else {
          // Fallback to original body string
          decryptedJsonString = response.body;
        }

        final decryptedData = json.decode(decryptedJsonString);

        setState(() {
          analyticsData = decryptedData;
          isLoading = false;

          if (analyticsData != null) {
            salesData = _generateSalesData();
          } else {
            errorMessage = 'No relevant data available';
          }
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load data';
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: $error';
      });
    }
  }

  List<ChartData> _generateSalesData() {
    List<ChartData> chartData = [];

    if (analyticsData!['topSellingShape'] != null) {
      var shape = analyticsData!['topSellingShape']['shape'] ?? 'Unknown';
      var count = analyticsData!['topSellingShape']['count'] ?? 0;
      chartData.add(ChartData(shape, count));
    }

    if (analyticsData!['mostProfitableShape'] != null) {
      var shape = analyticsData!['mostProfitableShape']['shape'] ?? 'Unknown';
      var profit = analyticsData!['mostProfitableShape']['profit'] ?? 0.0;
      chartData.add(ChartData(shape, profit));
    }

    return chartData;
  }

  String formatNumber(dynamic value) {
    num parsedValue = 0;
    if (value is num) {
      parsedValue = value;
    } else if (value is String) {
      parsedValue = num.tryParse(value) ?? 0;
    }
    return NumberFormat.compactCurrency(symbol: "\$").format(parsedValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: AppColors.secondaryColour,
        elevation: 1,
        title: Text(
          "Sale and Profit Analytics",
          style: TextStyleHelper.mediumPrimaryColour,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: AppColors.primaryColour,
          icon: Icon(Icons.arrow_back_ios_new_sharp),
        ),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : RefreshIndicator(
                onRefresh: fetchAnalytics,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPieChartCard(),
                      SizedBox(height: 20),
                      _buildAdminStatsGrid(),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildPieChartCard() {
    String? topShape = analyticsData?['topSellingShape']?['shape'];
    String? topPrevShape = analyticsData?['shapeChange']?['previousShape'];

    String? profitShape = analyticsData?['mostProfitableShape']?['shape'];
    String? profitPrevShape = analyticsData?['profitShapeChange']?['previousShape'];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SfCircularChart(
          title: ChartTitle(
            text: 'Sales & Profit by Shape',
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColour,
            ),
          ),
          legend: Legend(
            isVisible: true,
            position: LegendPosition.bottom,
            overflowMode: LegendItemOverflowMode.wrap,
            textStyle: TextStyle(color: AppColors.secondaryColour),
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CircularSeries>[
            PieSeries<ChartData, String>(
              dataSource: salesData,
              xValueMapper: (ChartData data, _) => data.category,
              yValueMapper: (ChartData data, _) => data.value,
              dataLabelMapper: (ChartData data, _) {
                String label = data.category;

                if (data.category == topShape && topPrevShape != null && topPrevShape != topShape) {
                  label += ' (prev: $topPrevShape)';
                }
                if (data.category == profitShape && profitPrevShape != null && profitPrevShape != profitShape) {
                  label += ' (prev: $profitPrevShape)';
                }

                return '$label: ${formatNumber(data.value)}';
              },
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(color: AppColors.backgroundBlack),
              ),
              pointColorMapper: (ChartData data, index) {
                final colors = [
                  AppColors.secondaryColour,
                  AppColors.greenLight,
                  AppColors.accentColour ?? Colors.orange,
                  Colors.purple,
                  Colors.redAccent,
                ];
                return colors[index % colors.length];
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminStatsGrid() {
    final stats = [
      {
        'title': 'Total Sales',
        'value': analyticsData?['totalSalesCount'],
        'icon': Icons.shopping_cart,
        'color': Colors.indigo,
      },
      {
        'title': 'Revenue',
        'value': analyticsData?['totalRevenue'],
        'icon': Icons.attach_money,
        'color': Colors.teal,
      },
      {
        'title': 'Profit',
        'value': analyticsData?['totalProfit'],
        'icon': Icons.trending_up,
        'color': Colors.green,
      },
      {
        'title': 'Avg Order',
        'value': analyticsData?['averageOrderValue'],
        'icon': Icons.receipt,
        'color': Colors.orange,
      },
      {
        'title': 'Inventory',
        'value': analyticsData?['totalInventoryCount'],
        'icon': Icons.inventory,
        'color': Colors.purple,
      },
      {
        'title': 'Customers',
        'value': analyticsData?['totalCustomers'],
        'icon': Icons.people,
        'color': Colors.redAccent,
      },
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children:
          stats.map((stat) {
            return _buildStatCard(
              stat['title']!,
              stat['value'],
              stat['icon'] as IconData,
              stat['color'] as Color,
            );
          }).toList(),
    );
  }

  Widget _buildStatCard(
    String title,
    dynamic value,
    IconData icon,
    Color color,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Text(
              formatNumber(value ?? 0),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String category;
  final num value;

  ChartData(this.category, this.value);
}
