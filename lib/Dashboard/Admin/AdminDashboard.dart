import 'package:daimo/Library/AppStrings.dart';
import 'package:flutter/material.dart';
import '../../Library/AppImages.dart';
import '../../Library/AppStyle.dart';
import '../../Library/Drawer.dart';
import '../../Library/AppColour.dart';
import 'package:get/get.dart';
import 'AddSupplier.dart';
import 'DiamondPurchase.dart';
import 'Inventory.dart';

class AdminDashboard extends StatelessWidget {
  final String? token;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AdminDashboard({Key? key, this.token}) : super(key: key);

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.primaryWhite,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColour,
        elevation: 1,
        title: Text(AppString.admin, style: TextStyleHelper.mediumPrimaryColour),
        leading: IconButton(
          icon: Icon(Icons.menu, color: AppColors.primaryColour),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: CommonDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColour,
              AppColors.secondaryColour,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildGrid(context),
                  const SizedBox(height: 30),
                  _ReportCard(
                    icon: Icons.bar_chart_rounded,
                    title: AppString.sellReport,
                  ),
                  const SizedBox(height: 16),
                  _ReportCard(
                    icon: Icons.assessment_outlined,
                    title: AppString.purchase,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primaryWhite,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryColour,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          _selectedIndex = index;
          switch (index) {
            case 0:
              Get.to(() => AdminDashboard());
              break;
            case 1:
            // Get.to(() => DiamondListScreen());
              break;
            case 2:
            // Get.to(() => OrdersPage());
              break;
            case 3:
            // Get.to(() => PurchasePage());
              break;
            case 4:
            // Get.to(() => AccountPage());
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.add_shopping_cart), label: 'PURCHASE'),
          BottomNavigationBarItem(icon: Icon(Icons.opacity_rounded), label: 'ORDER'),
          BottomNavigationBarItem(icon: Icon(Icons.publish_rounded), label: 'INQUIRY'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'REPORT'),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _DashboardCard(title: AppString.inventory, icon: Icons.diamond, onTap: () {
              Get.to(Inventory());
            }),
            _DashboardCard(title: AppString.purchase, icon: Icons.add_shopping_cart, onTap: () {
              Get.to(DiamondPurchaseForm());
            }),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _DashboardCard(title: AppString.addSupplier, icon: Icons.opacity_rounded, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddSupplier()));
            }),
            _DashboardCard(title: AppString.receiveOrder, icon: Icons.opacity_rounded, onTap: () {}),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _DashboardCard(title: AppString.inquiry, icon: Icons.add_task_outlined, onTap: () {}),
            _DashboardCard(title: AppString.history, icon: Icons.watch_later_outlined, onTap: () {}),
          ],
        ),
      ],
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardCard({Key? key, required this.title, required this.icon, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            height: 130,
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 40, color: AppColors.primaryColour),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColour,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const _ReportCard({Key? key, required this.icon, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.12),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: AppColors.primaryColour),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColour,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
