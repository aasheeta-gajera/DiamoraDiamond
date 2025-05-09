import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../Library/ApiService.dart';
import '../../../Library/AppColour.dart';
import '../../../Library/AppStyle.dart';

class ProfitMarginAnalyticsPage extends StatefulWidget {
  @override
  _ProfitMarginAnalyticsPageState createState() =>
      _ProfitMarginAnalyticsPageState();
}

class _ProfitMarginAnalyticsPageState extends State<ProfitMarginAnalyticsPage> {
  bool isLoading = true;
  String errorMessage = '';
  Map<String, dynamic>? profitData;

  @override
  void initState() {
    super.initState();
    fetchProfitMarginAnalytics();  // Fetch the profit margin data on init
  }

  // Fetching data from the API
  Future<void> fetchProfitMarginAnalytics() async {
    final String apiUrl =
        "${ApiService.baseUrl}/Report/getProfitMarginAnalytics";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          profitData = json.decode(response.body)['averageMarginByShape'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load profit data.';
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
    // Diamora theme colors
    final colors = {
      'primary': AppColors.secondaryColour, // Coral
      'secondary': AppColors.secondaryColour, // Lime Green
      'bg': Color(0xFFF7F7F7), // Light Gray
    };

    // Mapping the profit data into chart data format
    List<_ProfitData> chartData = [];
    profitData?.forEach((shape, margin) {
      chartData.add(_ProfitData(shape, double.parse(margin)));
    });

    return Scaffold(
      backgroundColor: colors['bg'],
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColour,
        elevation: 0,
        title: Text(
          "Profit Margin Analytics",
          style: TextStyleHelper.mediumPrimaryColour,
        ),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },color: AppColors.primaryColour, icon: Icon(Icons.arrow_back_ios_new_sharp),),

      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
        child: Text(errorMessage, style: TextStyle(color: AppColors.secondaryColour)),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Radial Bar Chart
              _buildRadialBarChart(chartData, colors),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to display the Radial Bar chart
  Widget _buildRadialBarChart(
      List<_ProfitData> data,
      Map<String, Color> colors,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading for the chart
        _buildChatBubble("Profit margin by shape (Radial Bar)", colors),
        SizedBox(height: 10),
        SfCircularChart(
          legend: Legend(
            isVisible: true,  // Shows the chart legend
            overflowMode: LegendItemOverflowMode.wrap,
          ),
          series: <RadialBarSeries<_ProfitData, String>>[
            RadialBarSeries<_ProfitData, String>(
              dataSource: data,  // Using the profit data for the chart
              xValueMapper: (_ProfitData d, _) => d.shape, // Labels for the chart
              yValueMapper: (_ProfitData d, _) => d.margin, // Profit margin values
              dataLabelSettings: DataLabelSettings(isVisible: true), // Shows the value on the chart
              maximumValue: 100,  // Set the max value for the radial bar (100% scale)
              cornerStyle: CornerStyle.bothCurve,  // Curved corners for aesthetic design
            ),
          ],
        ),
      ],
    );
  }

  // Custom widget for showing chat bubble-like messages
  Widget _buildChatBubble(String message, Map<String, Color> colors) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors['primary'],  // Chat bubble with Diamora's primary color
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(message, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

// Class for holding each profit data (shape and margin)
class _ProfitData {
  final String shape;  // Name of the shape (e.g., Round, Oval)
  final double margin; // Profit margin percentage

  _ProfitData(this.shape, this.margin);  // Constructor to initialize shape and margin
}
