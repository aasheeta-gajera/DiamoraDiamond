import 'package:flutter/material.dart';
import '../../Library/DiamondBackground.dart';
import '../../Library/Drawer.dart';
import '../../Library/AppColour.dart';
import '../../Library/AppStrings.dart';
import '../../Library/AppStyle.dart';
import 'package:get/get.dart';

import 'DiamondPurchaseScreen.dart';


class DiamondHomeAdmin extends StatelessWidget {
  final String? token;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DiamondHomeAdmin({Key? key, this.token}) : super(key: key);

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.primaryWhite,
      drawer: CommonDrawer(), // Drawer
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 40, bottom: 4),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        color: AppColors.primaryBlack,
                        onPressed: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        icon: Icon(Icons.menu, color: AppColors.primaryBlack),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.3),
                      const Text(
                        'Admin',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlack,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _buildGrid(context),
                  const SizedBox(height: 30),
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.report_gmailerrorred, size: 50, color: AppColors.primaryWhite),
                          SizedBox(height: 8),
                          Text(
                            "Sell Report",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade500,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
            _selectedIndex = index;
            switch (index) {
            case 0:
              Get.to(() => DiamondHomeAdmin());
              break;
            case 1:
             // Get.to(() => DiamondListScreen());
              break;
            case 2:
             // Get.to(() => OrdersPage());
              break;
            case 3:
              //Get.to(() => PurchasePage());
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
            _DiamondCard(title: "Inventory", icon: Icons.diamond, onTap: () {
              // Get.to(DiamondListScreen());
            },),
            _DiamondCard(title: "Purchase Diamond", icon: Icons.add_shopping_cart, onTap: () {
              Get.to(DiamondPurchaseForm());
            },),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _DiamondCard(title: "My Order", icon: Icons.opacity_rounded, onTap: () {},),
            _DiamondCard(title: "Inquiry", icon: Icons.add_task_outlined, onTap: () {},),
          ],
        ),
        const SizedBox(height: 20),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     _DiamondCard(title: "My Watchlist", icon: Icons.watch_later, onTap: () {},),
        //     _DiamondCard(title: "My Purchase", icon: Icons.publish_rounded, onTap: () {},),
        //   ],
        // ),
      ],
    );
  }
}

class _DiamondCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DiamondCard({Key? key, required this.title, required this.icon, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.grey[900],
        elevation: 6,
        shadowColor: Colors.grey.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.37,
          height: MediaQuery.of(context).size.width * 0.37,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primaryWhite, size: 40),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryWhite,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
