import 'dart:convert';
import 'package:daimo/Library/AppColour.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../Library/ApiService.dart';
import '../../../Library/AppStyle.dart';

class TimeBasedSalesPage extends StatefulWidget {
  @override
  _TimeBasedSalesPageState createState() => _TimeBasedSalesPageState();
}

class _TimeBasedSalesPageState extends State<TimeBasedSalesPage> {
  Map<String, dynamic>? salesData;
  bool isLoading = true;
  String errorMessage = '';
  late List<ChartData> dailySalesData;
  late List<ChartData> weeklySalesData;
  late List<ChartData> monthlySalesData;

  @override
  void initState() {
    super.initState();
    dailySalesData = [];
    weeklySalesData = [];
    monthlySalesData = [];
    fetchSalesData();
  }

  Future<void> fetchSalesData() async {
    final String apiUrl = "${ApiService.baseUrl}/Report/getTimeBasedSales";

    setState(() => isLoading = true);

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        String decryptedJsonString;

        if (responseBody is String) {
          decryptedJsonString = ApiService.decryptData(responseBody);
        } else if (responseBody is Map<String, dynamic> && responseBody.containsKey('data')) {
          decryptedJsonString = ApiService.decryptData(responseBody['data']);
        } else {
          decryptedJsonString = response.body;
        }

        final decryptedData = json.decode(decryptedJsonString);

        setState(() {
          salesData = decryptedData;
          isLoading = false;

          // Generate chart data from API response
          dailySalesData = _generateChartData(salesData?['dailySales']);
          weeklySalesData = _generateChartData(salesData?['weeklySales']);
          monthlySalesData = _generateChartData(salesData?['monthlySales']);
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
  List<ChartData> _generateChartData(Map<String, dynamic> sales) {
    List<ChartData> chartData = [];
    sales.forEach((key, value) {
      chartData.add(ChartData(key, value is int ? value.toDouble() : value));
    });
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColour,
        elevation: 0,
        title: Text(
          "Time-Based Sale Analytics",
          style: TextStyleHelper.mediumPrimaryColour,
        ),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },color: AppColors.primaryColour, icon: Icon(Icons.arrow_back_ios_new_sharp),),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isEmpty
          ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildKeyMetricsSection(),
              SizedBox(height: 20),
              _buildSalesChart('Daily Sales', dailySalesData),
              SizedBox(height: 20),
              _buildSalesChart('Weekly Sales', weeklySalesData),
              SizedBox(height: 20),
              _buildSalesChart('Monthly Sales', monthlySalesData),
            ],
          ),
        ),
      )
          : Center(child: Text(errorMessage, style: TextStyle(color: Colors.red))),
    );
  }

  // Key Metrics Section (e.g., Total Sales, Average Sales)
  Widget _buildKeyMetricsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildMetricCard('Total Sales', '\$200,000'),
        _buildMetricCard('Average Sales', '\$5,000'),
        _buildMetricCard('Highest Sales', '\$20,000'),
      ],
    );
  }

  // Metric Card widget
  Widget _buildMetricCard(String title, String value) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.primaryColour,  // Secondary color from Daimora theme
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5, spreadRadius: 2)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(value, style: TextStyle(color: Colors.white, fontSize: 18)),
        ],
      ),
    );
  }

  // Chart widget for time-based sales data
  Widget _buildSalesChart(String title, List<ChartData> chartData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryColour)),
        SizedBox(height: 10),
        SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          plotAreaBorderWidth: 0,
          backgroundColor: AppColors.secondaryColour,  // Light background color for the chart
          series: <CartesianSeries<ChartData, String>>[
            LineSeries<ChartData, String>(  // Smooth line graph
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.time,
              yValueMapper: (ChartData data, _) => data.salesAmount,
              name: title,
              color: AppColors.primaryColour,  // Line color from Daimora theme
              width: 3,  // Thicker line for better visibility
              markerSettings: MarkerSettings(
                isVisible: true,
                color: AppColors.primaryBlack,  // Marker color from theme
                shape: DataMarkerType.circle,
                borderWidth: 2,
              ),
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.top,
                textStyle: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ChartData {
  final String time;
  final double salesAmount;

  ChartData(this.time, this.salesAmount);
}
