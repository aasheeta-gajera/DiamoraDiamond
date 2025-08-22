import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../Library/ApiService.dart';
import '../../../Library/AppColour.dart';
import '../../../Library/AppStyle.dart';

class SearchAnalyticsPage extends StatefulWidget {
  @override
  _SearchAnalyticsPageState createState() => _SearchAnalyticsPageState();
}

class _SearchAnalyticsPageState extends State<SearchAnalyticsPage> {
  bool isLoading = true;
  String errorMessage = '';
  Map<String, dynamic>? searchAnalyticsData;

  @override
  void initState() {
    super.initState();
    fetchSearchAnalytics();
  }

  Future<void> fetchSearchAnalytics() async {
    final String apiUrl = "${ApiService.baseUrl}/Report/getSearchAnalytics";

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
          searchAnalyticsData = decryptedData;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load search analytics data.';
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
      'primary': AppColors.primaryColour, // Coral (Diamora theme)
      'secondary': Color(0xFF32CD32), // Lime Green
      'bg': Color(0xFFF7F7F7), // Light Gray background
    };

    return Scaffold(
      backgroundColor: colors['bg'],
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColour,
        elevation: 0,
        title: Text(
          "Search Analytics",
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
              _buildChatBubble("Total searches: ${searchAnalyticsData?['totalSearches']}", colors),
              SizedBox(height: 20),
              _buildChatBubble("Top 5 Searched Shapes", colors),
              _buildShapesChart(),
              SizedBox(height: 20),
              _buildChatBubble("No Result Searches", colors),
              _buildNoResultSearches(),
              SizedBox(height: 20),
              _buildChatBubble("Top 5 Popular Filters", colors),
              _buildFiltersChart(),
            ],
          ),
        ),
      ),
    );
  }

  // Display the shapes data in a chart
  Widget _buildShapesChart() {
    List<_SearchData> chartData = [];
    var topSearchedShapes = searchAnalyticsData?['topSearchedShapes'] as List;
    for (var item in topSearchedShapes) {
      chartData.add(_SearchData(item['shape'], item['count']));
    }

    return SfCircularChart(
      legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      series: <RadialBarSeries<_SearchData, String>>[
        RadialBarSeries<_SearchData, String>(
          dataSource: chartData,
          xValueMapper: (_SearchData d, _) => d.name,
          yValueMapper: (_SearchData d, _) => d.value,
          dataLabelSettings: DataLabelSettings(isVisible: true),
          maximumValue: 100,
          cornerStyle: CornerStyle.bothCurve,
        ),
      ],
    );
  }

  // Display popular filters data in a chart
  Widget _buildFiltersChart() {
    List<_SearchData> chartData = [];
    var popularFilters = searchAnalyticsData?['popularFilters'] as List;
    for (var item in popularFilters) {
      chartData.add(_SearchData(item['filter'], item['count']));
    }

    return SfCircularChart(
      legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      series: <RadialBarSeries<_SearchData, String>>[
        RadialBarSeries<_SearchData, String>(
          dataSource: chartData,
          xValueMapper: (_SearchData d, _) => d.name,
          yValueMapper: (_SearchData d, _) => d.value,
          dataLabelSettings: DataLabelSettings(isVisible: true),
          maximumValue: 100,
          cornerStyle: CornerStyle.bothCurve,
        ),
      ],
    );
  }

  // Display no-result searches as chat bubbles
  Widget _buildNoResultSearches() {
    var noResultSearches = searchAnalyticsData?['noResultSearches'] as List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: noResultSearches.map<Widget>((query) {
        return _buildChatBubble(query, {
          'primary': Color(0xFFB0BEC5), // Gray for no results
          'secondary': Color(0xFF32CD32),
          'bg': Color(0xFFF7F7F7),
        });
      }).toList(),
    );
  }

  // Custom chat bubble widget
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
}

// Data class to store shape and filter search data
class _SearchData {
  final String name;
  final int value;

  _SearchData(this.name, this.value);
}
