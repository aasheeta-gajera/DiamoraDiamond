import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../Library/ApiService.dart';

class SaleReport extends StatefulWidget {
  const SaleReport({Key? key}) : super(key: key);

  @override
  State<SaleReport> createState() => _SaleReportState();
}

class _SaleReportState extends State<SaleReport> {
  List<_ChartData> chartData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSalesData();
  }

  Future<void> fetchSalesData() async {
    try {
      final response = await http.get(Uri.parse("${ApiService.baseUrl}/getSalesReport"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List sales = data['sales'];

        Map<String, double> shapeSales = {};

        for (var sale in sales) {
          String shape = sale['shape'] ?? 'Unknown';
          double value = sale['totlePrice'] != null ? (sale['totlePrice'] as num).toDouble() : 0.0;

          // Accumulate the value by shape
          shapeSales[shape] = (shapeSales[shape] ?? 0) + value;
        }

        setState(() {
          chartData = shapeSales.entries
              .map((entry) => _ChartData(entry.key, entry.value))
              .toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load sales');
      }
    } catch (e) {
      print('Error: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sales Report (by Shape)')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : chartData.isEmpty
          ? const Center(child: Text('No sales data available'))
          : SfCircularChart(
        title: ChartTitle(text: 'Total Sales by Diamond Shape'),
        legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
        series: <DoughnutSeries<_ChartData, String>>[
          DoughnutSeries<_ChartData, String>(
            dataSource: chartData,
            xValueMapper: (_ChartData data, _) => data.category,
            yValueMapper: (_ChartData data, _) => data.value,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            pointColorMapper: (_ChartData data, _) {
              return _getColorForCategory(data.category);
            },
          ),
        ],
      ),
    );
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Round':
        return Colors.blue;
      case 'Oval':
        return Colors.green;
      case 'Square':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _ChartData {
  final String category;
  final double value;

  _ChartData(this.category, this.value);

  @override
  String toString() {
    return 'Category: $category, Value: $value';
  }
}
