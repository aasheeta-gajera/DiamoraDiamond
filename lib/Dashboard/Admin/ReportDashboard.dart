import 'package:flutter/material.dart';
import '../../Library/AppColour.dart';
import '../../Library/AppStyle.dart';
import 'Reports/CustomerAnalytics.dart';
import 'Reports/InventoryAnalytics.dart';
import 'Reports/OverallAnalytics.dart';
import 'Reports/ProfitMarginAnalytics.dart';
import 'Reports/SearchAnalytics.dart';
import 'Reports/TimeBasedSales.dart';

class ReportDashboard extends StatelessWidget {
  const ReportDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ReportItem> reports = [
      ReportItem(
        title: 'Sale Analytics',
        icon: Icons.analytics,
        color: AppColors.primaryColour,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AnalyticsDashboardPage()));
        },
      ),
      ReportItem(
        title: 'Time-Based Sale Analytics',
        icon: Icons.access_time,
        color: AppColors.primaryColour,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TimeBasedSalesPage()));
        },
      ),
      ReportItem(
        title: 'Customer Analytics',
        icon: Icons.people_alt,
        color: AppColors.primaryColour,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerAnalyticsPage()));
        },
      ),
      ReportItem(
        title: 'Inventory Analytics',
        icon: Icons.inventory_2,
        color: AppColors.primaryColour,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => InventoryAnalyticsPage()));
        },
      ),
      ReportItem(
        title: 'Profit Margin Analytics',
        icon: Icons.show_chart,
        color: AppColors.primaryColour,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfitMarginAnalyticsPage()));
        },
      ),
      ReportItem(
        title: 'Search Analytics',
        icon: Icons.search,
        color: AppColors.primaryColour,
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchAnalyticsPage()));
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColour,
        elevation: 5,
        title: Text(
          "Reports",
          style: TextStyleHelper.mediumPrimaryColour,
        ),
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, color: AppColors.primaryColour, icon: Icon(Icons.arrow_back_ios_new_sharp),),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryColour.withOpacity(0.9), AppColors.secondaryColour],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: reports.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final report = reports[index];
            return InkWell(
              onTap: report.onTap,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                  color: AppColors.primaryWhite,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: report.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        report.icon,
                        size: 35,
                        color: report.color,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        report.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primaryColour,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ReportItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  ReportItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
